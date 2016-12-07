package core.actors;

class BaseActorController
{
	var actorData:BaseActorData;
	var actorView:ActorView;

	public function new() 
	{
		
	}
	
	public function attachTo(actorData:BaseActorData, actorView:ActorView):Void
	{
		this.actorView = actorView;
		this.actorData = actorData;
	}
	
	public function update():Void
	{
		
	}
}