package;

import swfdata.SpriteData;
import swfdata.ShapeData;
import openfl.geom.Rectangle;
import openfl.display.FPS;
import by.blooddy.core.display.resource.ResourceDefinition;
import by.blooddy.core.display.resource.ResourceDefinition;
import ru.riot.display.gui.control.GUIDummy;
import ru.riot.display.gui.styles.FontStyles;
import ru.riot.display.gui.control.helpers.LabelHelper;
import flash.text.TextField;
import openfl.events.MouseEvent;
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
	var _tf:TextField;
	
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

		_tf  = LabelHelper.createLabel(FontStyles.getDynamicOpenSans(12, 0xFFFFFF));
		_tf.x = 10;
		_tf.y = 5;
		_tf.width = 1000;
		_tf.multiline = true;
		_tf.height = 100;
		_tf.text = "Click on the screen to add an animation\n";
		stage.addChild(_tf);

		var _fps = new FPS(10,10,0xffffff);
		_fps.y = 40;
		stage.addChild(_fps);
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
		stage.addEventListener(MouseEvent.CLICK, clickHandler);
		assetsManager.createUIAssets();
	}

	private function clickHandler(_):Void {
		var _x = 50;
		var _y = 125;

		for (displayObject in assetsManager.linkagesMap)
		{
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
			glStage.addDisplayObject(displayObject);
		}
		_tf.text =  "Click on the screen to add an animation\ncount: " + Std.string(glStage.numChildren);
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