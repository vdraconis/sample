package game.character;

import core.actors.ActorStates;
import core.actors.BaseActorController;
import core.external.keyboard.KeyBoardController;
import openfl.ui.Keyboard;

class KeyboardCharacterController extends BaseActorController
{
	var keyboardController:KeyBoardController;
	
	public function new(keyboardController:KeyBoardController) 
	{
		super();
		
		this.keyboardController = keyboardController;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (actorData.state == ActorStates.IDLE)
		{
			if (keyboardController.isKeyDown(Keyboard.W))
				actorData.y-=5;
			else if (keyboardController.isKeyDown(Keyboard.S))
				actorData.y+=5;
				
			if (keyboardController.isKeyDown(Keyboard.A))
				actorData.x-=5;
			else if (keyboardController.isKeyDown(Keyboard.D))
				actorData.x+=5;
		}
	}
}