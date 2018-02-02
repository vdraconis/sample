package core.actor;
import core.actor.BaseActorView;
import core.actor.BaseActor;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class PhysicActorController extends BaseActorController
{
	public var physicBody:Body;

	public function new() 
	{
		super();
	}
	
	override public function attachTo(actorData:BaseActorData, actorView:BaseActorView):Void 
	{
		super.attachTo(actorData, actorView);
		
		physicBody = new Body(BodyType.DYNAMIC);
		physicBody.shapes.add(new Polygon(Polygon.box(32, 32)));
		
	}
	
	override public function update():Void 
	{
		super.update();
			
		if (actorData.state == ActorStates.LOCKED)
		{
			actorData.x = physicBody.position.x;
			actorData.y = physicBody.position.y;
		}
		else
		{
			physicBody.position.x = actorData.x;
			physicBody.position.y = actorData.y;
		}
	}
}