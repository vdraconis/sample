package game.character;

import core.actor.ActorStates;
import core.actor.BaseActorView;
import core.actor.BaseActorController;
import core.actor.BaseActorData;
import core.actor.mobiles.MovementData;
import core.external.keyboard.KeyBoardController;
import lime.math.Vector2;
import openfl.ui.Keyboard;

class KeyboardCharacterController extends BaseActorController
{
	var keyboardController:KeyBoardController;
	
	var movementData:MovementData;

	public function new(keyboardController:KeyBoardController)
	{
		super();
		
		this.keyboardController = keyboardController;
	}
	
	override public function attachTo(actorData:BaseActorData, actorView:BaseActorView):Void 
	{
		super.attachTo(actorData, actorView);
		
		//movementData = actorData.movementData;
	}

	override public function update():Void
	{
		super.update();

		if (keyboardController.isKeysDown())
		{
			if (keyboardController.isKeyDown(Keyboard.W))
			{
				actorData.state = ActorStates.MOVE;
				movementData.direction.y = -1;
			}
			else if (keyboardController.isKeyDown(Keyboard.S))
			{
				actorData.state = ActorStates.MOVE;
				movementData.direction.y = 1;
			}
			else
				movementData.direction.y = 0;

			if (keyboardController.isKeyDown(Keyboard.A))
			{
				actorData.state = ActorStates.MOVE;
				movementData.direction.x = -1;
			}
			else if (keyboardController.isKeyDown(Keyboard.D))
			{
				actorData.state = ActorStates.MOVE;
				movementData.direction.x = 1;
			}
			else
				movementData.direction.x = 0;
		}
	}
}