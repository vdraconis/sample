package layers;
import gl.drawer.GLDisplayListDrawer;
import renderer.Renderer;
import openfl.geom.Matrix;
import swfdrawer.data.DrawingData;

/**
 * ...
 * @author gNikro
 */
class BaseLayer implements ILayer
{
	public var renderer:Renderer;
	public var mouseData:MouseData;
	public var drawer:GLDisplayListDrawer;
	public var drawingData:DrawingData;
	public var drawingMatrix:Matrix = new Matrix();

	public function new() 
	{
		
	}
	
	public function initialize(renderer:Renderer, mouseData:MouseData):Void
	{
		this.mouseData = mouseData;
		this.renderer = renderer;
		
		drawer = new GLDisplayListDrawer(null, mouseData.mousePosition);
		drawer.checkBounds = true;
		drawingData = new DrawingData();
		
		drawer.target = renderer;
		drawer.smooth = true;
	}
	
	public function update():Void 
	{
		
	}
	
}