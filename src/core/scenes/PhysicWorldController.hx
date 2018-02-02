package core.scenes;

import core.actor.BaseActor;
import core.actor.PhysicActorController;
import core.scenes.BaseSceneController;
import nape.space.Space;

class PhysicWorldController extends BaseSceneController
{
	var space:Space;

	public function new(space:Space) 
	{
		super();
		this.space = space;
		
		
	}
	
	override public function onActorAdd(actor:BaseActor):Void 
	{
		super.onActorAdd(actor);
		
		var physicActorController:PhysicActorController = cast actor.getController(PhysicActorController);
		
		if (physicActorController != null)
			physicActorController.physicBody.space = space;
	}
	
	override public function update():Void 
	{
		super.update();
		
		space.step(1 / 30);
	}
}