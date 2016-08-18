package;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Input;

/**
 * ...
 * @author ...
 */
class TestMain
{

	static function main() 
	{
		
		trace(main, main);
		
		//var bytesIntput:BytesInput;
		//var bytesOutput:BytesOutput
		
		
		var ByteArray:ByteArray = new ByteArray(null, 1024);
		ByteArray.writeInt(1234567);
		
		trace(ByteArray.length, ByteArray.position);
	
		ByteArray.position = 0;
		
		trace(ByteArray.readInt());
		
	}
	
}