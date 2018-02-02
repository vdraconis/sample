package game.character;

import core.actor.ActorStates;
import core.actor.mobiles.BaseMobileData;

class CharacterData extends BaseMobileData
{
	public function new() 
	{
		super();
		
		state = ActorStates.IDLE;
	}
}