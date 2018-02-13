 package;

import glStage.GlStage;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import renderer.TextureManager;
import swfdata.MovieClipData;
import swfdata.SpriteData;

class Main extends Sprite
{
	var context3D:Context3D;
	var glStage:GlStage;
	
	var assetsManager:AssetsManager;
	var bull:MovieClipData;
	
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
		
		assetsManager = new AssetsManager();
		assetsManager.addEventListener(Event.COMPLETE, onAssetReady);
	}
	
	private function onAssetReady(e:Event):Void 
	{
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		glStage = new GlStage(stage, context3D);
		
		bull = cast(assetsManager.linkagesMap["x1_0"]);
		bull.play();
		
		bull.x = stage.stageWidth / 2;
		bull.y = stage.stageHeight / 2;
		
		glStage.addDisplayObject(bull);
		
		bull = cast bull.clone();
		bull.stop();
		
		bull.x = stage.stageWidth / 2 - 150;
		bull.y = stage.stageHeight / 2;
		
		glStage.addDisplayObject(bull);
	}
	
	private function onUpdate(e:Event):Void 
	{	
		glStage.update();
	}
}