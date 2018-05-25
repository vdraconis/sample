package events;

class DataEvent extends Event
{
	static public inline var ON_LOAD:String = "onLoad";
	
	public var data:Dynamic;

	public function new(type:String, data:Dynamic) 
	{
		super(type);
		this.data = data;
	}
}