package core.actor.mobiles;

import core.actor.BaseActorData;

class BaseMobileData extends BaseActorData
{
	public var movementData:MovementData = new MovementData();
	
	public function new() 
	{
		super();
	}
}