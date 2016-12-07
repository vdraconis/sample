package core.scenes;

import core.scenes.BaseScene;
import core.scenes.PhysicWorldController;
import glStage.Stage;
import nape.geom.Vec2;
import nape.space.Space;

class PhysicWorldScene extends BaseScene
{
	public var space:Space;

	public function new(stage:Stage) 
	{
		super(stage);
		
		space = new Space(new Vec2());
		sceneControllers.push(new PhysicWorldController(space));
	}
}