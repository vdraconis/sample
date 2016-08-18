package;

import layers.LayersContainer;
import layers.sceneLayer.GameScene;
import layers.sceneLayer.Scene;
import layers.uiLayer.UILayer;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.textures.Texture;
import openfl.events.ContextMenuEvent;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import renderer.TextureManager;

class Main extends Sprite
{
	var layersController:LayersContainer;
	
	var context3D:Context3D;
	var bgTexture:Texture;
	
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
		
		var assetsLoader:AssetsLoader = new AssetsLoader();
		//var outlineAtlas:GLTextureAtlas = new GLTextureAtlas("outline", Assets.getBitmapData("img/outline_pattern.png", true), Context3DTextureFormat.BGRA, 0);
		//outlineAtlas.uploadToGpu();
		//renderer = new Renderer(context3D, cast outlineAtlas.createSubTexture2(0, new Rectangle(0, 0, 64, 64), 1, 1, 1), light);
		
		layersController = new LayersContainer(context3D);
		
		var actorsScene:Scene = new GameScene(assetsLoader);
		//actorsScene.globalColorBuffer = light;
		layersController.addLayer(actorsScene);
		//layersController.addLayer(new UILayer(assetsLoader.createUIAssets()));
		
		
		addChild(layersController);
	}
	
	private function onMenuSelect(e:ContextMenuEvent):Void 
	{
		e.preventDefault();
	}
	
	private function onUpdate(e:Event):Void 
	{
		layersController.update();
		
		//light.r = light.g = light.b = 1-(uiLayer.sldier.value > 0.9? 0.9:uiLayer.sldier.value);
	}
}