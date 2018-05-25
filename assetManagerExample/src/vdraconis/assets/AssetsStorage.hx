package vdraconis.assets;

import haxe.io.Bytes;

class AssetsStorage 
{
	var binaryAssets:Map<String, BinaryAsset> = new Map();
	
	public function new() 
	{
		
	}
	
	public function getAsset(fileName:String):BinaryAsset
	{
		return binaryAssets.get(fileName);
	}

    public function hasAsset(fileName:String):Bool
    {
        return binaryAssets.exists(fileName);
    }
	
	public function addAsset(fileName:String, extension:String, data:Bytes) 
	{
		var asset:BinaryAsset = new BinaryAsset(fileName, extension, data);
		binaryAssets.set(fileName, asset);
	}
}