package core.scenes;

import glStage.Stage;
import openfl.Vector;
import core.actor.BaseActor;

class BaseScene
{
	var sceneControllers:Vector<BaseSceneController> = new Vector<BaseSceneController>();
	var actorsList:Vector<BaseActor> = new Vector<BaseActor>();
	var stage:Stage;
	
	public function new(stage:Stage) 
	{
		this.stage = stage;
	}
	
	public function addActor(actor:BaseActor):Void
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