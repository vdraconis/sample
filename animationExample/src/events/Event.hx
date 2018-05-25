package events;

class Event
{
	static public inline var COMPLETE:String = "complete";
	static public inline var UPDATE:String = "update";
	
	public var type:String;
	
	public function new(type:String) 
	{
		this.type = type;
	}
}