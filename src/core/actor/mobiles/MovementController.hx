package core.actor.mobiles;

import core.actor.BaseActorView;
import core.actor.BaseActorData;
import core.actor.mobiles.MovementData;
import lime.math.Vector2;

class MovementController extends BaseActorController
{
	private var movementVector:Vector2 = new Vector2();
	var movementData:MovementData;
	
	public function new() 
	{
		super();
	}
	
	override public function attachTo(actorData:BaseActorData, actorView:BaseActorView):Void 
	{
		super.attachTo(actorData, actorView);
		
		//movementData = actorData.movementData;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (actorData.state == ActorStates.MOVE)
		{
			movementData.currentSpeed += movementData.acceleration;
		}
		
		if (movementData.direction.x != 0 || movementData.direction.y != 0)
		{
			movementVector.setTo(movementData.direction.x, movementData.direction.y);
			
			movementVector.x *= movementData.currentSpeed;
			movementVector.y *= movementData.currentSpeed;
			
			actorData.x += movementVector.x;
			actorData.y += movementVector.y;
		}
		
		movementData.currentSpeed *= actorData.state == ActorStates.MOVE? 0.95:0.8;
		
		if (movementData.currentSpeed < 0.01)
			movementData.currentSpeed = 0;
	}
}