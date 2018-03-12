package assets;

class Asset<T>
{
	public var extension(get, null):String;
	public var name(get, null):String;
	public var content(get, null):T;
	
	public function new(name:String, extension:String, content:T) 
	{
		this.content = content;
		this.extension = extension;
		this.name = name;
	}
	
	function get_content():T 
	{
		return content;
	}
	
	function get_extension():String 
	{
		return extension;
	}
	
	function get_name():String 
	{
		return name;
	}
}