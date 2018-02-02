package events;

import haxe.Constraints.Function;

class Observer implements IObserver
{
	private var describes:Map<String, Array<Function>> = new Map<String, Array<Function>>();
	
	public function new() 
	{
		
	}

	public function addEventListener(type:String, callback:Function):Void
	{
		var callbackList:Array<Function> = describes[type];
		
		if (callbackList == null)
		{
			callbackList = new Array<Function>();
			describes[type] = callbackList;
		}
		
		callbackList.push(callback);
	}
	
	public function dispatchEvent(event:Event):Void
	{
		var callbackList:Array<Function> = describes[event.type];
		
		if (callbackList != null)
		{
			for (callback in callbackList)
			{
				callback(event);
			}
		}
	}
}