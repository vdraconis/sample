package layers.sceneLayer;

import gl.drawer.GLDisplayListDrawer;
import layers.BaseLayer;
import layers.MouseData;
import layers.sceneLayer.Actor;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import renderer.Renderer;
import swfdata.ColorData;
import swfdrawer.data.DrawingData;

class Scene extends BaseLayer
{
	public var actorsList:Array<Actor> = new Array<Actor>();
	
	public var viewPort:Rectangle = new Rectangle(0, 0, 800, 800);
	private var viewPortBuffer:Rectangle = new Rectangle(0, 0, 0, 0);
	
	public var rightDown:Bool;
	public var leftClick:Bool;
	
	public var globalColorMultiplayer:ColorData = new ColorData(1, 1, 1, 1);
	public var globalColorBuffer:ColorData = new ColorData(1, 1, 1, 1);

	public function new() 
	{
		super();
	}
	
	public function addActor(actor:Actor)
	{
		actorsList.push(actor);
	}
	
	override public function update():Void
	{	
		var isCheckDrawingBounds:Bool = false;
		
		drawer.checkMouseHit = mouseData.isLeftDown;
		
		viewPort.x += mouseData.mouseMove.x;
		viewPort.y += mouseData.mouseMove.y;
		
		var x:Float = viewPort.x;
		var y:Float = viewPort.y;
		
		viewPortBuffer.x = -x;
		viewPortBuffer.y = -y;
		viewPortBuffer.width = -x + viewPort.width;
		viewPortBuffer.height = -y + viewPort.height;
		
		for (i in 0...actorsList.length)
		{
			var currentActor:Actor = actorsList[i];
			
			var pos:Point = currentActor.position;
			pos = toScreen(pos.x, pos.y);
			
			var drawingBound:Rectangle = currentActor.bounds;
			
			isCheckDrawingBounds = drawingBound.width == 0 && drawingBound.height == 0;
			
			if (!isCheckDrawingBounds)
			{
				//trace(viewPort, drawingBound);
				currentActor.visible = !(drawingBound.x + drawingBound.width < viewPortBuffer.x || drawingBound.y + drawingBound.height < viewPortBuffer.y ||
										drawingBound.x > viewPortBuffer.width || drawingBound.y > viewPortBuffer.height);
			}
			
			if (currentActor.visible == false)
				continue;
				
			if(!isCheckDrawingBounds)
				currentActor.update();
			
			globalColorBuffer.r = globalColorMultiplayer.r;
			globalColorBuffer.g = globalColorMultiplayer.g;
			globalColorBuffer.b = globalColorMultiplayer.b;
			globalColorBuffer.a = globalColorMultiplayer.a;
			
			drawer.atlas = currentActor.atlas;
			
			if (isCheckDrawingBounds)
			{
				drawingBound.setTo(0, 0, 0, 0);
				drawer.checkBounds = true;
			}
			else
				drawer.checkBounds = false;
				
			globalColorBuffer.mulColorData(currentActor.colorData);
			
			drawingMatrix.setTo(1, 0, 0, 1, x + pos.x, y + pos.y);
			
			drawer.drawDisplayObject(currentActor.view, drawingMatrix, drawingBound, globalColorBuffer);
			
			if (isCheckDrawingBounds)
			{
				drawingBound.x -= x;
				drawingBound.y -= y;
			}
			
			if (drawer.isHitMouse == true && currentActor.isUnderMouse == false)
			{
				//if(mouseData.isRightDown)
				//	currentActor.onRightMouseDown();
				//else
				if(mouseData.isLeftDown)
					currentActor.onMouseDown();
			}
			
			if (drawer.isHitMouse == false && currentActor.isUnderMouse == true)
			{
				currentActor.onMouseUp();
				//currentActor.onRightMouseUp();
			}
			
			currentActor.isUnderMouse = drawer.isHitMouse;
		}
	}
	
	var _RECT_WIDTH:Float = 48;
	var _RECT_HEIGHT:Float = 24;
	
	var _RECT_HALF_WIDTH:Float = 48 / 2;
	var _RECT_HALF_HEIGHT:Float = 24 / 2;
	
	var TEMP_POINT:Point = new Point();
	
	
	function toScreen(x:Float, y:Float):Point 
	{
		var col:Float = x;
		var row:Float = y;
		TEMP_POINT.x = (col - row) * _RECT_HALF_WIDTH;
		TEMP_POINT.y = (row + col) * _RECT_HALF_HEIGHT;
		
		return TEMP_POINT;
	}

	function toTile(x:Float, y:Float):Point
	{
		var v1:Float = (x - _RECT_HALF_WIDTH) / _RECT_WIDTH;
		var v2:Float = (y / _RECT_HEIGHT);
		var rx:Float = (v1 + v2);
		var ry:Float = (v2 - v1);
		
		TEMP_POINT.x = (Std.int(rx) | 0) + (rx < 0 ? -1 : 0);
		TEMP_POINT.y = (Std.int(ry) | 0) + (ry < 0 ? -1 : 0);
		
		return TEMP_POINT;
	}
}