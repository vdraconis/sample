package;

import openfl.Assets;
import openfl.text.TextFormat;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import swfdata.SpriteData;
import swfdata.atlas.GLTextureAtlas;
import swfdata.atlas.ITextureAtlas;
import swfdata.datatags.SwfPackerTag;
import swfdataexporter.SwfExporter;
import swfparser.SwfParserLight;

class AssetsLoader
{
	static function get_instance():AssetsLoader
	{
		if (instance == null)
			instance = new AssetsLoader();
			
		return instance;
	}
	
	@:isVar
	static public var instance(get, null):AssetsLoader;
	
	public var linkagesMap:Map<String, SpriteData> = new Map<String, SpriteData>();
	public var atlasMap:Map<String, ITextureAtlas> = new Map<String, ITextureAtlas>();
	
	
	public function new() 
	{
		parseAsset("animation/bull_smith.animation");
		parseAsset("animation/bath.animation");
		parseAsset("animation/albion_mirabelle.animation");
		parseAsset("animation/circus.animation");
		parseAsset("animation/amure_lemure.animation");
		parseAsset("animation/valentine2016_kisses.animation");
		parseAsset("animation/chestnut_tree.animation");
		parseAsset("animation/pinetree.animation");
		parseAsset("animation/cypress.animation");	
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
		var swfExporter:SwfExporter = new SwfExporter();
		var swfParserLight:SwfParserLight = new SwfParserLight();
		var swfTags:Array<SwfPackerTag> = new Array<SwfPackerTag>();
		
		var data:ByteArray = Assets.getBytes(path);
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