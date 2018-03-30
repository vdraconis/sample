package;

import motion.easing.Linear;
import motion.Actuate;
import openfl.text.TextField;
import swfdata.DisplayObjectData;
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
import utils.DisplayObjectUtils;

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

		stage.addEventListener(Event.RESIZE, onResize);


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
		//assetsManager.addEventListener(Event.COMPLETE, onAssetReady);
		onAssetReady(null);
	}

    private function onResize(e:Event):Void {
        context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, true);
    }

    private function onAssetReady(e:Event):Void
	{	
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		var _x = 50;
		var _y = 125;
		
		assetsManager.createUIAssets();

		for(i in 0...10)
		for (displayObject in assetsManager.linkagesMap)
		{
			if (i > 0)
				displayObject = displayObject.clone();
			displayObject.x = _x;
			displayObject.y = _y;
			
			_x += 50;
			
			if (_x + 50 > stage.stageWidth)
			{
				_x = 50;
				_y += 100;
			}

            addTween(displayObject);
			
			var mc = DisplayObjectUtils.asMovieClip(displayObject); //for common types not DisplayObject types use Lang.as - return null or type; Lang.as2 - return object or type
            if (mc != null) {
                // TODO кажется что-то случилось)
                //mc.gotoAndPlay(Std.int(Math.random() * mc.timeline.framesCount - 1));
                //mc.gotoAndPlay(0);
            }
			
			glStage.addDisplayObject(displayObject);
		}
		
		var tf = new TextField();
		tf.text = "TEST";
		addChild(tf);
	}

    private function addTween(displayObject:DisplayObjectData):Void {
        var onCompleteTween:Dynamic;

        onCompleteTween = function(_){
            Actuate
            .tween(displayObject, Math.random() * 10,{
                x: Math.random()* stage.stageWidth,
                y: Math.random()* stage.stageHeight
            })
            .ease(Linear.easeNone)
            .onComplete(onCompleteTween);
        };

        onCompleteTween();
    }
	
	private function onUpdate(e:Event):Void 
	{	
		glStage.update();
	}
}