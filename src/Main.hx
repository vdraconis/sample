 package;

import core.external.keyboard.KeyBoardController;
import core.scenes.PhysicWorldScene;
import game.scenes.GameScene;
import nape.util.BitmapDebug;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import renderer.TextureManager;

class Main extends Sprite
{
	var context3D:Context3D;
	var glStage:glStage.Stage;
	
	var worldScene:GameScene;
	var debug:BitmapDebug;
	
	public function new() 
	{
		super();
		
		this.mouseChildren = false;
		this.mouseEnabled = false;
		
		if (stage != null)
			initialize();
		else
			addEventListener(Event.ADDED_TO_STAGE, initialize);
	}
	
	private function initialize(e:Event = null):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, initialize);
		
		stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, onContextCreatedError);
		stage.stage3Ds[0].requestContext3D("auto");
	}
	
	private function onContextCreatedError(e:ErrorEvent):Void 
	{
		trace(e);
	}
	
	@:access(_internal)
	private function onContextCreated(e:Event):Void 
	{
		context3D = stage.stage3Ds[0].context3D;
		context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, true);
		context3D.setCulling(Context3DTriangleFace.NONE);
		
		context3D.enableErrorChecking = true;
		context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		
		TextureManager.context = context3D;	
		
		var keyboardController:KeyBoardController = new KeyBoardController(stage);
		
		var assetsLoader:AssetsLoader = AssetsLoader.instance;
		
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		glStage = new glStage.Stage(context3D);
		
		worldScene = new GameScene(glStage, stage, keyboardController);
		
		debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color, true);
        addChild(debug.display);
	}
	
	private function onUpdate(e:Event):Void 
	{
		worldScene.update();
		
		debug.clear();
		debug.draw(worldScene.space);
		debug.flush();
		
		
	}
}