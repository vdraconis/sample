package game.scenes;

import core.actor.BaseActorView;
import core.actor.mobiles.MovementController;
import core.external.keyboard.KeyBoardController;
import core.scenes.PhysicWorldScene;
import game.MouseMoveInput;
import game.character.Character;
import game.character.CharacterData;
import game.character.KeyboardCharacterController;
import game.character.PlayerController;
import glStage.Stage;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.ShapeData;
import swfdata.SpriteData;

class GameScene extends PhysicWorldScene
{
	var keyboardController:KeyBoardController;
	var characterData:CharacterData;
	var protoObject:SpriteData;
	var nativeStage:openfl.display.Stage;

	public function new(stage:Stage, nativeStage:openfl.display.Stage, keyboardController:KeyBoardController) 
	{
		super(stage);
		this.nativeStage = nativeStage;
		
		this.keyboardController = keyboardController;
		
		protoObject = new SpriteData(0);
		protoObject.addDisplayObject(new ShapeData(0, new Rectangle(0, 0, 32, 32)));
		protoObject.transform = new Matrix();
		
		var atlasGenerator:AtlasGenerator = new AtlasGenerator(32, 32);
		atlasGenerator.addSubTexture(new BitmapData(32, 32, false, 0xFFFFFF), 0, 1, 1);
		protoObject.atlas = atlasGenerator.createGlAtlas();
		
		spawn();
	}
	
	public function spawn():Void
	{
		characterData = new CharacterData();
		var actor:Character = new Character(new BaseActorView(protoObject, characterData), characterData);
		
		actor.addController(new PlayerController(new MouseMoveInput(nativeStage)));
		
		addActor(actor);
	}
	
	override public function update():Void 
	{
		super.update();
		
		characterData.state = 1;
	}
}