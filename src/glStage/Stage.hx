package glStage;

import gl.drawer.GLDisplayListDrawer;
import openfl.display3D.Context3D;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import renderer.Renderer;
import swfdata.DisplayObjectContainer;

class Stage extends DisplayObjectContainer
{
	var drawingMatrix:Matrix = new Matrix();
	var drawingBound:Rectangle = new Rectangle();
	var movieClipDrawer:GLDisplayListDrawer;
	var renderer:Renderer;
	
	public function new(context3D:Context3D) 
	{
		super();
		
		renderer = new Renderer(context3D);
		movieClipDrawer = new GLDisplayListDrawer();
		movieClipDrawer.target = renderer;
	}
	
	override public function update():Void
	{
		super.update();
		
		renderer.begin();
		
		drawingBound.setTo(0, 0, 0, 0);
		
		for (spriteData in _displayObjects)
		{
			movieClipDrawer.atlas = spriteData.atlas;
			movieClipDrawer.drawDisplayObject(spriteData, drawingMatrix, drawingBound);
		}
		
		renderer.render();
		renderer.end();
	}
}