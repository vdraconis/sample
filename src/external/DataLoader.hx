package external;

import js.Browser;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;

class AssetDataEvent extends Event 
{
	static public inline var ON_LOAD:String = "onLoad";
	
	public var data:Dynamic;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, data:Dynamic)
	{
		super(type, bubbles, cancelable);
		this.data = data;
	}
}

class DataLoader extends EventDispatcher
{
	private var httpRequest:XMLHttpRequest;
	
	public function new() 
	{
		super();
		
		httpRequest = Browser.createXMLHttpRequest();
		httpRequest.onload = onLoadComplete;
		httpRequest.responseType = XMLHttpRequestResponseType.ARRAYBUFFER;
	}
	
	public function load(path:String, type:XMLHttpRequestResponseType):Void
	{
		
		httpRequest.open("GET", path, true);
		httpRequest.send();
	}
	
	private function onLoadComplete() 
	{
		var data:Dynamic = httpRequest.response;
		
		dispatchEvent(new AssetDataEvent(AssetDataEvent.ON_LOAD, false, false, data));
	}
}