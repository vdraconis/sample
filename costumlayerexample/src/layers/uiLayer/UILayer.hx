package layers.uiLayer;

import gl.drawer.GLDisplayListDrawer;
import layers.BaseLayer;
import layers.ILayer;
import layers.MouseData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;
import renderer.Renderer;
import swfdata.atlas.GLTextureAtlas;
import swfdata.ColorData;
import swfdata.DisplayObjectTypes;
import swfdata.ShapeData;
import swfdata.SpriteData;
import swfdrawer.data.DrawingData;

class UILayer extends BaseLayer
{
	var atlas:GLTextureAtlas;
	
	var colorData:ColorData = new ColorData();
	
	var displayList:Vector<SpriteData> = new Vector<SpriteData>();
	
	public var sldier:Slider;
	
	public var isMouseHit:Bool = false;
	
	public function new(atlas:GLTextureAtlas) 
	{
		super();
		
		this.atlas = atlas;
		
		sldier = new Slider(getShape(0, "sliderEnd"), getShape(4, "sliderBg"), getShape(1, "slider"), getShape(6, "label1"), getShape(7, "label2"));
		sldier.transform = new Matrix();
		sldier.transform.tx = 10;
		sldier.transform.ty = 10;
		
		displayList[0] = sldier;
	}
	
	override public function initialize(renderer:Renderer, mouseData:MouseData):Void 
	{
		super.initialize(renderer, mouseData);
		
		drawer.atlas = atlas;
		drawer.checkBounds = false;
	}
	
	override public function update():Void
	{
		isMouseHit = false;
		
		drawer.checkMouseHit = true;
		var mouseX:Float = mouseData.mousePosition.x;
		var mouseY:Float = mouseData.mousePosition.y;
		
		for (spriteData in displayList)
		{
			drawer.drawDisplayObject(spriteData, drawingMatrix);
			
			spriteData.mouseX = mouseX;
			spriteData.mouseY = mouseY;
			
			spriteData.update();
			
			if (mouseData.isLeftDown && drawer.isHitMouse && !spriteData.isMouseDown)
				spriteData.onMouseDown();
			
			if (!mouseData.isLeftDown && spriteData.isMouseDown)
				spriteData.onMouseUp();
			
			if (drawer.isHitMouse)
			{
				if (!spriteData.isMouseOver)
					spriteData.onMouseOver();
			}
			else
			{
				if (spriteData.isMouseOver)
					spriteData.onMouseOut();
			}
			
			isMouseHit = drawer.isHitMouse || spriteData.isMouseDown;
		}
	}
	
	function getShape(id:Int, name:String):ShapeData
	{
		var bd:Rectangle = atlas.getTexture(id).bounds;
		var shape:ShapeData = new ShapeData(id, new Rectangle(0, 0, bd.width, bd.height));
		shape.name = name;
		
		return shape;
	}
}