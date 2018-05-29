package;

import AtlasGenerator;
import assets.AssetLoader;
import assets.AssetsStorage;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import renderer.TextureManager;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.SpriteData;
import swfdata.atlas.TextureId;
import swfdata.atlas.TextureSource;
import swfdata.atlas.TextureStorage;
import swfdata.datatags.SwfPackerTag;
import swfdataexporter.SwfExporter;
import swfparser.SwfParserLight;

class AssetsManager extends EventDispatcher
{
	var assetsStorage:AssetsStorage;
	var textureStorage:TextureStorage;
	var textureManager:TextureManager;
	var swfExporter:SwfExporter;
	var swfParserLight:SwfParserLight;
	
	var atlasGenerator:AtlasGenerator = new AtlasGenerator();
	
	public var linkagesMap:Map<String, DisplayObjectData> = new Map<String, DisplayObjectData>();
	
	public function new(textureStorage:TextureStorage, textureManager:TextureManager)
	{
		super();
		
		this.textureManager = textureManager;
		this.textureStorage = textureStorage;
		
		assetsStorage = new AssetsStorage();
		var assetsLoader:AssetLoader = new AssetLoader(assetsStorage);
		assetsLoader.addToQueue("animation/a.ani");
		assetsLoader.addToQueue("animation/biker.ani");
		assetsLoader.addToQueue("animation/teslagirl.ani");
		//assetsLoader.addToQueue("animation/bath.animation");
		//assetsLoader.addToQueue("animation/albion_mirabelle.animation");
		//assetsLoader.addToQueue("animation/circus.animation");
		//assetsLoader.addToQueue("animation/amure_lemure.animation");
		//assetsLoader.addToQueue("animation/valentine2016_kisses.animation");
		//assetsLoader.addToQueue("animation/chestnut_tree.animation");
		//assetsLoader.addToQueue("animation/pinetree.animation");
		//assetsLoader.addToQueue("animation/cypress.animation");	
		
		
		
		assetsLoader.addEventListener(Event.COMPLETE, onAssetsLoaded);
		assetsLoader.load();
	}
	
	private function onAssetsLoaded(e:Event):Void 
	{
		parseAsset("animation/a.ani");
		parseAsset("animation/biker.ani");
		parseAsset("animation/teslagirl.ani");
		//parseAsset("animation/bath.animation");
		//parseAsset("animation/albion_mirabelle.animation");
		//parseAsset("animation/circus.animation");
		//parseAsset("animation/amure_lemure.animation");
		//parseAsset("animation/valentine2016_kisses.animation");
		//parseAsset("animation/chestnut_tree.animation");
		//parseAsset("animation/pinetree.animation");
		//parseAsset("animation/cypress.animation");	
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	public function createCustomAtlas(width:Int, height:Int):TextureSource
	{
		var atlasData:BitmapData = new BitmapData(width, height, true, 0x0);
		var textureSource = new TextureSource(atlasData, width, height, textureManager);
		
		return textureSource;
	}
	
	public function uploadAtlasData(textureSource:TextureSource)
	{
		textureSource.createGlData(Context3DTextureFormat.BGRA);
		textureSource.uploadToGpu();
	}
	
	public function switchAtlas(bitmapData:BitmapData)
	{
		atlasGenerator.setBitmapData(bitmapData);
	}
	
	public function createCustomSprite(atlasID:Int, textureId:Int, textureSource:TextureSource, spriteData:BitmapData, scaleX:Float = 1, scaleY:Float = 1)
	{
		var combinedTextureId = new TextureId(atlasID, textureId);
		atlasGenerator.addTexture(textureStorage, combinedTextureId, textureSource, spriteData, textureId, scaleX, scaleY);
		
		var shape = new ShapeData(combinedTextureId, new Rectangle(0, 0, spriteData.width, spriteData.height));
		shape.transform = new Matrix();
		
		linkagesMap["shape:"+combinedTextureId.toString()] = shape;
		
		return shape;
	}

	public function createUIAssets()
	{
		var textureSource = createCustomAtlas(1024, 1024);
		var atlasID = textureStorage.getNextTextureId();
		var textureID:Int = 0;
		switchAtlas(textureSource.source);
		
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_sliderUp.png", true), 0.5, 0.5);
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_sliderEnd.png", true));
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_circle.png", true));
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_sliderVertical.png", true));
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_sliderHorizontal.png", true));
		createCustomSprite(atlasID, textureID++, textureSource, Assets.getBitmapData("ui/grey_sliderRight.png", true));

		uploadAtlasData(textureSource);
		
		//var format:TextFormat = AssetContainer TextFormat("Verdana", 12, 0x333333, false);
		//atlasGenerator.addText("Morning", format, textureID++);
		//atlasGenerator.addText("Midnight", format, textureID++);
	}
	
	@:access(swfdata)
	private function parseAsset(path:String) 
	{
		var swfTags = new Array<SwfPackerTag>();
		
		//TODO: need to reuse swfExporter and parser and use CLEAR instead of making AssetContainer instance everytime
		swfExporter = new SwfExporter(textureStorage, textureManager);
		swfParserLight = new SwfParserLight();
		
		var data:ByteArray = assetsStorage.getAsset(path).content;
		data.endian = Endian.LITTLE_ENDIAN;
		
		swfExporter.importSwfGL(data, swfParserLight.context.shapeLibrary, swfTags);
		
		swfParserLight.context.library.addShapes(swfParserLight.context.shapeLibrary);
		swfParserLight.processDisplayObject(swfTags);
		
		for (spriteData in swfParserLight.context.library.linkagesList)
		{
			var key = spriteData.libraryLinkage + path;
			linkagesMap[key] = spriteData;
		}
		
	}
}