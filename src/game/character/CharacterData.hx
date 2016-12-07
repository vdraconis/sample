package game.character;

import core.actors.ActorStates;
import core.actors.BaseActorData;

class CharacterData extends BaseActorData
{
	public function new() 
	{
		super();
		
		state = ActorStates.IDLE;
	}
}