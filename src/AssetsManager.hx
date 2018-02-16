package;

import assets.AssetLoader;
import assets.AssetsStorage;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.TextFormat;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import swfdata.SpriteData;
import swfdata.atlas.GLTextureAtlas;
import swfdata.atlas.ITextureAtlas;
import swfdata.datatags.SwfPackerTag;
import swfdataexporter.SwfExporter;
import swfparser.SwfParserLight;

class AssetsManager extends EventDispatcher
{
	var assetsStorage:AssetsStorage;
	
	public var linkagesMap:Map<String, SpriteData> = new Map<String, SpriteData>();
	public var atlasMap:Map<String, ITextureAtlas> = new Map<String, ITextureAtlas>();
	
	public function new() 
	{
		super();
		
		assetsStorage = new AssetsStorage();
		var assetsLoader:AssetLoader = new AssetLoader(assetsStorage);
		assetsLoader.addToQueue("animation/biker.ani");
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
		parseAsset("animation/biker.ani");
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
	
	public function createUIAssets():GLTextureAtlas
	{
		var atlasGenerator:AtlasGenerator = new AtlasGenerator(1024, 1024);
		var textureID:Int = 0;
		
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_sliderEnd.png", true), textureID++);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_sliderUp.png", true), textureID++, 0.5, 0.5);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_circle.png", true), textureID++);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_sliderVertical.png", true), textureID++);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_sliderHorizontal.png", true), textureID++);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_sliderRight.png", true), textureID++);
		atlasGenerator.addSubTexture(Assets.getBitmapData("ui/grey_button15.png", true), textureID++);
		
		var format:TextFormat = new TextFormat("Verdana", 12, 0x333333, false);
		atlasGenerator.addText("Morning", format, textureID++);
		atlasGenerator.addText("Midnight", format, textureID++);
		
		return atlasGenerator.createGlAtlas();
	}
	
	@:access(swfdata)
	private function parseAsset(path:String) 
	{
		var swfExporter:SwfExporter = new SwfExporter();
		var swfParserLight:SwfParserLight = new SwfParserLight();
		var swfTags:Array<SwfPackerTag> = new Array<SwfPackerTag>();
		
		var data:ByteArray = assetsStorage.getAsset(path).content;
		data.endian = Endian.LITTLE_ENDIAN;
		
		var textureAtlas:GLTextureAtlas = swfExporter.importSwfGL(data, swfParserLight.context.shapeLibrary, swfTags);
		
		swfParserLight.context.library.addShapes(swfParserLight.context.shapeLibrary);
		swfParserLight.processDisplayObject(swfTags);
		
		for (spriteData in swfParserLight.context.library.linkagesList)
		{
			linkagesMap[spriteData.libraryLinkage] = spriteData;
			atlasMap[spriteData.libraryLinkage] = textureAtlas;
			
			spriteData.atlas = textureAtlas;
		}
	}
}