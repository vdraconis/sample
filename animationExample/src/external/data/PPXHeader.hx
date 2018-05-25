package external.data;

import haxe.io.Bytes;

class PPXHeader 
{
	public static inline var HEADER_SIZE:Int = 3 * 2;
	
	public static inline var sig:Int = 10;
	public var width:Int = 0;
	public var height:Int = 0;
	
	public function new() 
	{
		
	}
	
	public static function fromBytes(bytes:Bytes):PPXHeader
	{
		var nullByte = bytes.get(0);
		var sig = bytes.get(1);
		var width = bytes.getUInt16(2);
		var height = bytes.getUInt16(4);
		
		if (sig != PPXHeader.sig || nullByte != 0)
			throw "PPXHeader signature not match to file signature";
			
		var header:PPXHeader = new PPXHeader();
		header.width = width;
		header.height = height;
		
		//trace("ppx data header");
		//trace('width = $width');
		//trace('height = $height');
		//trace('sig = $sig, $nullByte');
		//trace('size = ${bytes.length}');
		
		return header;
	}
	
}