package vdraconis.assets;

import AtlasGenerator;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display3D.Context3DTextureFormat;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import renderer.TextureManager;
import swfdata.atlas.TextureId;
import swfdata.atlas.TextureSource;
import swfdata.atlas.TextureStorage;
import swfdata.datatags.SwfPackerTag;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
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
	}

    public function load(path:String, linkageName:String, onComplete:Dynamic->Void, onError:Dynamic->Void):Void
    {
        var key = path ;
        if (linkageName != null)
            key = path + "#" + linkageName;

        var finish = function():Void {
            if (linkagesMap.exists(key)) {
                onComplete(null);
            } else {
                trace("ERROR no linkageName " + linkageName + " in " + path);
                onError(null);
            }
        }

        if (assetsStorage.hasAsset(path)) {
            finish();
        } else {
            var assetLoader = new AssetLoader(assetsStorage);
            assetLoader.addToQueue(path);
            var onCompleteLoader:Dynamic -> Void;
            onCompleteLoader = function(_):Void {
                assetLoader.removeEventListener(Event.COMPLETE, onCompleteLoader);
                if (linkageName != null){
                    parseAsset(path);
                    finish();
                } else {
                    var loader = new Loader();
                    var onCompleteLoadBytes: Dynamic -> Void;
                    onCompleteLoadBytes = function(_) {
                        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoadBytes);
                        var bitmapData = cast (loader.content, Bitmap).bitmapData;
                        createShapeFromBitmap(key, bitmapData);
                        finish();
                    }
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadBytes);
                    loader.loadBytes(assetsStorage.getAsset(path).content);
                }
            }
            assetLoader.addEventListener(Event.COMPLETE, onCompleteLoader);
            assetLoader.load();
        }
    }
	
	private function onAssetsLoaded(e:Event):Void {
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	public function createCustomAtlas(width:Int, height:Int):TextureSource {
		var atlasData:BitmapData = new BitmapData(width, height, true, 0x0);
		var textureSource = new TextureSource(atlasData, width, height, textureManager);
		
		return textureSource;
	}
	
	public function uploadAtlasData(textureSource:TextureSource) {
		textureSource.createGlData(Context3DTextureFormat.BGRA);
		textureSource.uploadToGpu();
	}
	
	public function switchAtlas(bitmapData:BitmapData) {
		atlasGenerator.setBitmapData(bitmapData);
	}
	
	public function createCustomSprite(atlasID:Int, textureId:Int, textureSource:TextureSource, spriteData:BitmapData, scaleX:Float = 1, scaleY:Float = 1):ShapeData {
		var combinedTextureId = new TextureId(atlasID, textureId);
		atlasGenerator.addTexture(textureStorage, combinedTextureId, textureSource, spriteData, textureId, scaleX, scaleY);
		
		var shape = new ShapeData(combinedTextureId, new Rectangle(0, 0, spriteData.width, spriteData.height));
		shape.transform = new Matrix();
		
		return shape;
	}


    public function createShapeFromBitmap(path:String, bitmapData:BitmapData) {
        if (linkagesMap.exists(path))
            return linkagesMap[path].clone();
        var textureSource = createCustomAtlas(bitmapData.width, bitmapData.height);
        var atlasID = textureStorage.getNextTextureId();
        var textureID:Int = 0;
        switchAtlas(textureSource.source);
        var shape = createCustomSprite(atlasID, textureID++, textureSource, bitmapData);
        linkagesMap[path] = shape;
        uploadAtlasData(textureSource);
        return shape;
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
			var key = path + "#" + spriteData.libraryLinkage;
            trace(key);
			linkagesMap[key] = spriteData;
		}
		
	}
}