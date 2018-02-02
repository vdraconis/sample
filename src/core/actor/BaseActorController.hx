package core.actor;

class BaseActorController
{
	var actorData:BaseActorData;
	var actorView:BaseActorView;

	public function new() 
	{
		
	}
	
	public function attachTo(actorData:BaseActorData, actorView:BaseActorView):Void
	{
		this.actorView = actorView;
		this.actorData = actorData;
	}
	
	public function update():Void
	{
		
	}
}