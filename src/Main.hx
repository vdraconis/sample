package;

import gl.GlStage;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import renderer.Renderer;
import renderer.TextureManager;
import swfdata.MovieClipData;
import swfdata.atlas.TextureStorage;

@:access(openfl.display3D.Context3D)
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
		
		@:privateAccess context3D.__vertexConstants = new lime.utils.Float32Array(4 * Renderer.MAX_VERTEX_CONSTANTS);
		@:privateAccess context3D.__fragmentConstants = new lime.utils.Float32Array(4 * Renderer.MAX_VERTEX_CONSTANTS);
		
		context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, true);
		context3D.setCulling(Context3DTriangleFace.NONE);
		
		//#if debug
		//	context3D.enableErrorChecking = true;
		//#end
		
		context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		
		var textureManager:TextureManager = new TextureManager(context3D);
		var textureStorage:TextureStorage = new TextureStorage();
		
		glStage = new GlStage(stage, context3D, textureStorage);
		
		assetsManager = new AssetsManager(textureStorage, textureManager);
		assetsManager.addEventListener(Event.COMPLETE, onAssetReady);
	}
	
	private function onAssetReady(e:Event):Void 
	{	
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		var _x = 50;
		var _y = 125;
		for (displayObject in assetsManager.linkagesMap)
		{
			displayObject.x = _x;
			displayObject.y = _y;
			
			//displayObject.transform.scale(4, 4);
			
			_x += 50;
			
			if (_x + 50 > stage.stageWidth)
			{
				_x = 50;
				_y += 100;
			}
			
			glStage.addDisplayObject(displayObject);
		}
	}
	
	private function onUpdate(e:Event):Void 
	{	
		glStage.update();
	}
}