package layers;

import openfl.Vector;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import renderer.Renderer;
import swfdata.ColorData;

class LayersContainer extends Sprite
{
	var context3D:Context3D;
	var renderer:Renderer;
	
	var clickPosition:Point = new Point();
	
	var mouseData:MouseData = new MouseData();

	var layers:Vector<BaseLayer> = new Vector<BaseLayer>();
	
	var handleMouse:Bool = false;
	
	public function new(context3D:Context3D) 
	{
		super();
		
		this.context3D = context3D;
		
		var globalLight:ColorData = new ColorData();
		renderer = new Renderer(context3D);
		
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
	}
	
	private function onRightDown(e:MouseEvent):Void 
	{
		mouseData.isRightDown = true;
		e.stopImmediatePropagation();
		e.preventDefault();
	}
	
	private function onRightUp(e:MouseEvent):Void 
	{
		mouseData.isRightDown = false;
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		mouseData.isLeftDown = false;
		handleMouse = false;
		mouseData.mouseMove.setTo(0, 0);
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		mouseData.isLeftDown = true;
		handleMouse = true;
		clickPosition.setTo(mouseX, mouseY);
	}
	
	private function onMouseMove():Void 
	{
		mouseData.mousePosition.setTo(mouseX, mouseY);
		mouseData.mouseMove.setTo(mouseX - clickPosition.x, mouseY - clickPosition.y);
			
		clickPosition.setTo(mouseX, mouseY);
		
		/*for (layer in layers)
		{
			if (layers.isMouseHit)
			{
				
			}
		}*/
	}
	
	private function onUpdate(e:Event):Void 
	{
		update();
	}
	
	public function addLayer(layer:BaseLayer):Void
	{
		layers.push(layer);
		layer.initialize(renderer, mouseData);
	}
	
	public function update():Void
	{
		if (handleMouse)
			onMouseMove();
			
		renderer.begin();
		//renderer.__drawBG();
			
		for (layer in layers)
		{
			layer.update();
		}
		
		renderer.render();
		renderer.end();
	}
}