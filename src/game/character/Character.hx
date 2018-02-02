package game.character;

import core.actor.BaseActor;
import core.actor.BaseActorView;
import core.actor.BaseActorData;
import core.actor.mobiles.BaseMobileData;

class Character extends BaseActor
{
	public function new(actorView:BaseActorView, actorData:BaseMobileData) 
	{
		super(actorView, actorData);
	}
}