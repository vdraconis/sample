package vdraconis.assets;

import js.html.XMLHttpRequestResponseType;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import vdraconis.assets.DataLoader.AssetDataEvent;

@:access(haxe.io.Bytes)
class AssetLoader extends EventDispatcher
{
	var loadQue:Array<String> = [];
	
	var binaryTypes:Array<String> = ["animation", "ani", "ppx", "jpg", "jpeg", "png"];
	
	var currentLoading:String;
	
	var dataLoader:DataLoader = new DataLoader();
	var assetsStorage:AssetsStorage;
	
	var filesLoaded:Int;
	var filesTotal:Int;
	var isLoadInProgress:Bool;
	
	public function new(assetsStorage:AssetsStorage) 
	{
		super();
		this.assetsStorage = assetsStorage;
		initalize();
	}
	
	private function initalize() 
	{
		dataLoader.addEventListener(AssetDataEvent.ON_LOAD, loadComplete);
	}
	
	public function addToQueue(path:String)
	{
		loadQue.push(path);
		filesTotal++;
		//var fileExtension:String = path.substr(path.lastIndexOf("."), path.length);
	}
	
	public function load()
	{
		loadNext();
	}
	
	function isBinary(extension:String):Bool
	{
		return binaryTypes.indexOf(extension) != -1;
	}
	
	function loadNext()
	{
		if (isLoadInProgress)
			return;
		
		currentLoading = loadQue.shift();
		var extension:String = getExtension(currentLoading);
		var isBinary:Bool = isBinary(extension);
		
		if (isBinary)
		{
			loadBinary(currentLoading);
		}
		else
		{
			throw "unknown type";
		}
	}
	
	function getExtension(value:String):String 
	{
		var extensionPosition = value.lastIndexOf('.') + 1;
		return value.substr(extensionPosition, value.length - extensionPosition);
	}
	
	function loadComplete(e:AssetDataEvent):Void 
	{
		filesLoaded++;
		
		var slashIndex:Int = currentLoading.indexOf("/") + 1;
		
		var extension:String = getExtension(currentLoading);
		var fileName:String = currentLoading;// .substr(0, currentLoading.indexOf(extension));
		var data:haxe.io.Bytes = new haxe.io.Bytes(e.data);
		
		assetsStorage.addAsset(fileName, extension, data);
		
		if (loadQue.length == 0)
		{
			finishLoading();
			return;
		}
		else
		{
			loadNext();
		}
	}
	
	function finishLoading() 
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	function loadBinary(path:String) 
	{
		dataLoader.load(path, XMLHttpRequestResponseType.ARRAYBUFFER);
	}
}