package core.actor;

import core.actor.BaseActorView;
import core.actor.PhysicActorController;
import openfl.Vector;

class BaseActor
{
	public var actorView:BaseActorView;
	
	var actorData:BaseActorData;
	
	var controllers:Vector<BaseActorController> = new Vector<BaseActorController>();
	
	public function new(actorView:BaseActorView, actorData:BaseActorData) 
	{
		this.actorData = actorData;
		this.actorView = actorView;
	}
	
	public function getController(type:Class<BaseActorController>):BaseActorController
	{
		for (controller in controllers)
		{
			if (Std.is(controller, type))
				return controller;
		}
		
		return null;
	}
	
	public function addController(controller:BaseActorController):Void
	{
		controllers.push(controller);
		controller.attachTo(actorData, actorView);
	}
	
	public function update():Void
	{
		actorData.state = ActorStates.IDLE;
		
		for (actorController in controllers)
		{
			actorController.update();
		}
		
		actorView.update();
	}
}