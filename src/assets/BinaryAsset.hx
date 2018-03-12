package assets;

import haxe.io.Bytes;

class BinaryAsset extends Asset<Bytes>
{
	public function new(name:String, extension:String, content:Bytes) 
	{
		super(name, extension, content);
	}
}