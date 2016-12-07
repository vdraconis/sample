package core.actors;

import swfdata.SpriteData;

class ActorView
{
	var actorData:BaseActorData;
	public var spriteData:SpriteData;

	public function new(spriteData:SpriteData, actorData:BaseActorData) 
	{
		this.actorData = actorData;
		this.spriteData = spriteData;
	}
	
	public function update():Void
	{
		spriteData.transform.tx = actorData.x;
		spriteData.transform.ty = actorData.y;
	}
}