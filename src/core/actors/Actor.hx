package core.actors;

import core.actors.ActorView;
import core.actors.PhysicActorController;
import openfl.Vector;

class Actor
{
	public var actorView:ActorView;
	var actorData:BaseActorData;
	
	var controllers:Vector<BaseActorController> = new Vector<BaseActorController>();
	
	public function new(actorView:ActorView, actorData:BaseActorData) 
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
		for (actorController in controllers)
		{
			actorController.update();
		}
		
		actorView.update();
	}
}