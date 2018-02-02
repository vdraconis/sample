package game.character;

import core.actor.BaseActorController;
import game.MouseMoveInput;

class PlayerController extends BaseActorController
{
	var mouseMovementInput:MouseMoveInput;

	public function new(mouseMovementInput:MouseMoveInput) 
	{
		super();
		
		this.mouseMovementInput = mouseMovementInput;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var angleX:Float = mouseMovementInput.dragVector.x;
		
		//GeomMath.protate(actorData.direction, angleX);
	}
}