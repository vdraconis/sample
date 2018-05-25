package;
import swfdata.atlas.TextureId;

class TestMain
{

	static function main() 
	{
		var textureId:TextureId = 0;
		textureId.textureId = 1024;
		textureId.atlasId = 512;
		
		trace(textureId, textureId.textureId, textureId.atlasId);
		
		textureId.textureId = 2222;
		trace(textureId, textureId.textureId, textureId.atlasId);
		
		textureId.textureId = 5555;
		textureId.atlasId = 4444;
		trace(textureId, textureId.textureId, textureId.atlasId);
		
			
		var i = 0;
		
		i = i | 512 << 16;
		
		trace(untyped i.toString(2), i);
		
		i = i | 1024;
		var z = i >> 16;
		trace(untyped z.toString(2), z);
		var k = i & 65535;// i << 16 >> 16;
		trace(untyped k.toString(2), k);
		trace(textureId.toString(2));

	}
}