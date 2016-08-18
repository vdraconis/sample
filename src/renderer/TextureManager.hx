package renderer;

import flash.display3D.Context3D;
import openfl.display3D.textures.Texture;
import openfl.display.BitmapData;

class TextureManager
{
	public static var context:Context3D;
	
	public function new() 
	{
		
	}
	
	static public function createTexture(id:String, atlasData:BitmapData, format:String):Texture
	{
		return context.createTexture(atlasData.width, atlasData.height, format, false);
	}
	
}