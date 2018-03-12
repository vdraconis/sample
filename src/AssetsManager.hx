package;

import AtlasGenerator;
import assets.AssetLoader;
import assets.AssetsStorage;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.TextFormat;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import renderer.TextureManager;
import swfdata.SpriteData;
import swfdata.atlas.GLTextureAtlas;
import swfdata.atlas.TextureStorage;
import swfdata.datatags.SwfPackerTag;
import swfdataexporter.SwfExporter;
import swfparser.SwfParserLight;

class AssetsManager extends EventDispatcher
{
	var assetsStorage:AssetsStorage;
	var textureSotrage:TextureStorage;
	var textureManager:TextureManager;
	
	public var linkagesMap:Map<String, SpriteData> = new Map<String, SpriteData>();
	
	public function new(textureSotrage:TextureStorage, textureManager:TextureManager) 
	{
		super();
		
		this.textureManager = textureManager;
		this.textureSotrage = textureSotrage;
		
		assetsStorage = new AssetsStorage();
		var assetsLoader:AssetLoader = new AssetLoader(assetsStorage);
		assetsLoader.addToQueue("animation/tank.ani");
		assetsLoader.addToQueue("animation/a.ani");
		assetsLoader.addToQueue("animation/x.ani");
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
		parseAsset("animation/tank.ani");
		parseAsset("animation/biker.ani");
		parseAsset("animation/teslagirl.ani");
		parseAsset("animation/a.ani");
		parseAsset("animation/x.ani");
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
		
		var format:TextFormat = new TextFormat("Verdana", 12, 0x333333, false);
		atlasGenerator.addText("Morning", format, textureID++);
		atlasGenerator.addText("Midnight", format, textureID++);
		
		return atlasGenerator.createGlAtlas();
	}
	
	@:access(swfdata)
	private function parseAsset(path:String) 
	{
		var swfExporter:SwfExporter = new SwfExporter(textureSotrage, textureManager);
		var swfParserLight:SwfParserLight = new SwfParserLight();
		var swfTags:Array<SwfPackerTag> = new Array<SwfPackerTag>();
		
		var data:ByteArray = assetsStorage.getAsset(path).content;
		data.endian = Endian.LITTLE_ENDIAN;
		
		swfExporter.importSwfGL(data, swfParserLight.context.shapeLibrary, swfTags);
		
		swfParserLight.context.library.addShapes(swfParserLight.context.shapeLibrary);
		swfParserLight.processDisplayObject(swfTags);
		
		for (spriteData in swfParserLight.context.library.linkagesList)
		{
			linkagesMap[spriteData.libraryLinkage + path] = spriteData;
		}
	}
}