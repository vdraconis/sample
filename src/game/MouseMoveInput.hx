package game;

import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

class MouseMoveInput
{
	var stage:Stage;
	
	var startDragPosition:Point = new Point();
	var lastPosition:Point = new Point();
	public var dragVector:Point = new Point();
	
	var isDragging:Bool = false;

	public function new(stage:Stage) 
	{
		this.stage = stage;
		initalize();
	}
	
	private function initalize():Void
	{
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
		stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function onStartDrag(e:MouseEvent):Void 
	{
		isDragging = true;
		
		lastPosition.setTo(e.stageX, e.stageY);
	}
	
	private function onStopDrag(e:MouseEvent):Void 
	{
		isDragging = false;
		dragVector.setTo(0, 0);
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if (isDragging == false)
			return;
			
		dragVector.setTo(e.stageX - lastPosition.x, e.stageY - lastPosition.y);
		lastPosition.setTo(e.stageX, e.stageY);
	}
	
	private function update(e:Event):Void 
	{
		dragVector.setTo(0, 0);
	}
}