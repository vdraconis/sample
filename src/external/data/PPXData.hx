package external.data;

import haxe.io.Bytes;
import haxe.io.UInt16Array;

class PPXData 
{
	public var data:Bytes;
	public var header:PPXHeader;
	
	public function new(data:Bytes) 
	{
		header = PPXHeader.fromBytes(data);
		this.data = Bytes.alloc(data.length - PPXHeader.HEADER_SIZE);
		this.data.blit(0, data, PPXHeader.HEADER_SIZE, data.length - PPXHeader.HEADER_SIZE);	
	}
}