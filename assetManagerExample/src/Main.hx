package;

import vdraconis.assets.AssetContainer;
import vdraconis.assets.Scene;
import flash.text.TextField;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import swfdata.DisplayObjectData;

@:access(openfl.display3D.Context3D)
class Main extends Sprite
{
	var _tf:TextField;
	var _scene:Scene;
	
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

		_scene = new Scene(stage);
		_scene.addEventListener(Event.INIT, onInit);

		_tf = new TextField();
		_tf.x = 10;
		_tf.y = 5;
		_tf.width = 1000;
		_tf.multiline = true;
		_tf.height = 100;
        _tf.textColor = 0xFFFFFF;
		_tf.text = "Click on the screen to add an animation\n";
		stage.addChild(_tf);

		var _fps = new FPS(10,10,0xffffff);
		_fps.y = 40;
		stage.addChild(_fps);
	}
	
	private function onInit(e:Event):Void {
		_scene.removeEventListener(Event.INIT, onInit);
		stage.addEventListener(MouseEvent.CLICK, onClick);
		var bg = new AssetContainer("bg/may_9.jpg");
        _scene.glStage.addDisplayObject(bg);
	}

	private function onClick(_):Void {
		var _x = 50;
		var _y = 125;

		//for (i in 1...10)
		{

            var container = new AssetContainer("animation/biker.ani","x2_90");
            var displayObject:DisplayObjectData = container;
            // А если добавляем контент на стэйдж. то анимация есть
             if (container.content != null)
                displayObject = container.content;

			displayObject.x = _x;
			displayObject.y = _y;

			_x += 50;

			if (_x + 50 > stage.stageWidth)
			{
				_x = 50;
				_y += 100;
			}

            addTween(displayObject);
            _scene.glStage.addDisplayObject(displayObject);
		}
		_tf.text =  "Click on the screen to add an animation\ncount: " + Std.string(_scene.glStage.numChildren);
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
	

}