package core.scenes;

import glStage.Stage;
import openfl.Vector;
import core.actors.Actor;

class BaseScene
{
	var sceneControllers:Vector<BaseSceneController> = new Vector<BaseSceneController>();
	var actorsList:Vector<Actor> = new Vector<Actor>();
	var stage:Stage;
	
	public function new(stage:Stage) 
	{
		this.stage = stage;
	}
	
	public function addActor(actor:Actor):Void
	{
		actorsList.push(actor);
		stage.addDisplayObject(actor.actorView.spriteData);
		
		for (sceneController in sceneControllers)
			sceneController.onActorAdd(actor);
	}
	
	public function update():Void
	{
		for (sceneController in sceneControllers)
			sceneController.update();
			
		for (actor in actorsList)
		{
			actor.update();
		}
		
		stage.update();
	}
}