package layers.sceneLayer;

import layers.MouseData;
import openfl.Vector;
import openfl.geom.Point;
import renderer.Renderer;
import swfdata.atlas.GLSubTexture;

class InfinityBackground
{
	public var HELPER_BUFFER:Vector<Float> = new Vector<Float>(16, true);
	
	var texture:GLSubTexture;
	var position:Point = new Point();
	var mouseData:MouseData;

	public function new(texture:GLSubTexture, mouseData:MouseData) 
	{
		this.mouseData = mouseData;
		this.texture = texture;
	}
	
	@:access(internal)
	public function render(renderer:Renderer):Void
	{
		position.x += mouseData.mouseMove.x;
		position.y += mouseData.mouseMove.y;
		
		var scale:Float = 800 / 256;
		var size:Float = 250; 
		
		HELPER_BUFFER[0] = scale;
		HELPER_BUFFER[1] = 0;
		HELPER_BUFFER[2] = 0;
		HELPER_BUFFER[3] = scale;
		HELPER_BUFFER[4] = 400;
		HELPER_BUFFER[5] = 400;
		HELPER_BUFFER[6] = 256;
		HELPER_BUFFER[7] = 256;
		HELPER_BUFFER[8] = -position.x/size;
		HELPER_BUFFER[9] = -position.y/size;
		HELPER_BUFFER[10] = scale;
		HELPER_BUFFER[11] = scale;
		HELPER_BUFFER[12] = 1;// light.r;
		HELPER_BUFFER[13] = 1;// light.g;
		HELPER_BUFFER[14] = 1;// light.b;
		HELPER_BUFFER[15] = 1;// light.a;
		
		renderer.drawRawTexture(texture, HELPER_BUFFER);
		//renderer.__draw();
	}
}