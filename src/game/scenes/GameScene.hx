package game.scenes;

import core.actors.ActorView;
import core.actors.PhysicActorController;
import core.external.keyboard.KeyBoardController;
import core.scenes.PhysicWorldScene;
import game.character.Character;
import game.character.CharacterData;
import game.character.KeyboardCharacterController;
import glStage.Stage;
import openfl.geom.Matrix;
import swfdata.MovieClipData;

class GameScene extends PhysicWorldScene
{
	var keyboardController:KeyBoardController;
	var characterData:CharacterData;

	public function new(stage:Stage, keyboardController:KeyBoardController) 
	{
		super(stage);
		this.keyboardController = keyboardController;
		
		spawn();
	}
	
	public function spawn():Void
	{
		var bull:MovieClipData = cast(AssetsLoader.instance.linkagesMap["bull_smith"]);
		bull.play();
		
		characterData = new CharacterData();
		var actor:Character = new Character(new ActorView(bull, characterData), characterData);
		actor.addController(new PhysicActorController());
		actor.addController(new KeyboardCharacterController(keyboardController));
		addActor(actor);
		
		
		characterData = new CharacterData();
		characterData.x = 200;
		characterData.y = 200;
		
		
		var atlas = bull.atlas;
		bull = cast bull.clone();
		bull.transform = new Matrix();
		bull.atlas = atlas;
		
		actor = new Character(new ActorView(bull, characterData), characterData);
		actor.addController(new PhysicActorController());
		addActor(actor);
	}
	
	override public function update():Void 
	{
		super.update();
		
		characterData.state = 1;
	}
}