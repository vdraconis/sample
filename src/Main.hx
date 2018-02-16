 package;

import glStage.GlStage;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import renderer.TextureManager;
import swfdata.MovieClipData;
import swfdata.ShapeData;
import swfdata.SpriteData;
import swfdata.atlas.GLTextureAtlas;

class Main extends Sprite
{
	var context3D:Context3D;
	var glStage:GlStage;
	
	var assetsManager:AssetsManager;
	
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
		
		context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		
		TextureManager.context = context3D;	
		
		assetsManager = new AssetsManager();
		assetsManager.addEventListener(Event.COMPLETE, onAssetReady);
	}
	
	var atlas:GLTextureAtlas;
	private function onAssetReady(e:Event):Void 
	{	
		glStage = new GlStage(stage, this.graphics, context3D);
		
		atlas = assetsManager.createUIAssets();
		var shape = getShape(6, 'button15');
		shape.atlas = atlas;
		
		shape.x = 0;
		shape.y = 100;
		shape.transform = new Matrix();
		//shape.transform.scale(1, 3);
		//shape.transform.rotate(Math.PI / 4);
		//shape.tx = 100;
		//shape.ty = 100;
		
		glStage.addDisplayObject(shape);
		
		var b = new Bitmap(cast(shape.atlas, GLTextureAtlas).atlasData, null, false);
		b.alpha = 0.85;
		addChild(b);
		
		
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		return;
		
		var _x = 350;
		var _y = 400;
		for (displayObject in assetsManager.linkagesMap)
		{
			displayObject.x = _x;
			displayObject.y = _y;
			
			displayObject.transform.scale(4, 4);
			
			_x += 50;
			
			if (_x + 50 > stage.stageWidth)
			{
				_x = 50;
				_y += 100;
			}
			
			glStage.addDisplayObject(displayObject);
			
			var b = new Bitmap(cast(displayObject.atlas, GLTextureAtlas).atlasData, null, false);
			b.alpha = 0.85;
			addChild(b);
			return;
		}
	}
	
	function getShape(id:Int, name:String = null):ShapeData
	{
		var bd:Rectangle = atlas.getTexture(id).bounds;
		var shape:ShapeData = new ShapeData(id, new Rectangle(0, 0, bd.width, bd.height));
		shape.name = name;
		
		return shape;
	}
	
	private function onUpdate(e:Event):Void 
	{	
		glStage.update();
	}
}