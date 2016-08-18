package layers.uiLayer;

import openfl.geom.Point;

import swfdata.ColorData;
import swfdata.DisplayObjectTypes;
import swfdata.ShapeData;
import swfdata.SpriteData;

class Slider extends SpriteData
{
	var sliderEnd:ShapeData;
	var sliderBg:ShapeData;
	var slider:ShapeData;
	var label1:ShapeData;
	var label2:ShapeData;
	
	public var value:Float = 0;
	
	var sliderPosition:Float = 0;
	var isDrag:Bool = false;
	
	var dragPosition:Point = new Point();
	
	public function new(sliderEnd:ShapeData, sliderBg:ShapeData, slider:ShapeData, label1:ShapeData, label2:ShapeData) 
	{
		super(0, DisplayObjectTypes.SPRITE_TYPE, true, 0);
		
		this.colorData = new ColorData();
		
		this.label2 = label2;
		this.label1 = label1;
		this.slider = slider;
		this.sliderBg = sliderBg;
		this.sliderEnd = sliderEnd;
		
		addDisplayObject(sliderBg);
		addDisplayObject(label1);
		addDisplayObject(label2);
		addDisplayObject(sliderEnd);
		addDisplayObject(slider);
		
		label1.x = 0;
		label1.y = 0;
		
		sliderBg.x = label1.x + label1.width + 1;
		sliderBg.y = (label1.height - sliderBg.height) / 2;
		
		label2.x = sliderBg.x + sliderBg.width + 1;
		
		sliderPosition = sliderBg.width * value;
		setSlider();
	}
	
	override public function update():Void 
	{
		if (!isDrag)
			return;
			
		var dx:Float = mouseX - dragPosition.x;
		
		sliderPosition += dx;
		
		if (sliderPosition < 0)
			sliderPosition = 0;
		
		if (sliderPosition > sliderBg.width)
			sliderPosition = sliderBg.width;
		
		value = sliderPosition / sliderBg.width;
		
		if (value > 1)
			value = 1;
			
		if (value < 0)
			value = 0;
		
		setSlider();
		
		dragPosition.setTo(mouseX, mouseY);
	}
	
	override public function onMouseDown():Void 
	{
		isDrag = true;
		
		dragPosition.setTo(mouseX, mouseY);
		
		super.onMouseDown();
		
		colorData.r = 1.35;
		colorData.g = 1.35;
		colorData.b = 1.35;
	}
	
	override public function onMouseUp():Void 
	{
		isDrag = false;
		
		super.onMouseUp();
		
		if (isMouseOver)
		{
			colorData.r = 1.2;
			colorData.g = 1.2;
			colorData.b = 1.2;
		}
		else
		{
			colorData.r = 1.0;
			colorData.g = 1.0;
			colorData.b = 1.0;
		}
	}
	
	override public function onMouseOut():Void 
	{
		super.onMouseOut();
		
		colorData.r = 1.0;
		colorData.g = 1.0;
		colorData.b = 1.0;
	}
	
	override public function onMouseOver():Void 
	{
		super.onMouseOver();
		
		colorData.r = 1.2;
		colorData.g = 1.2;
		colorData.b = 1.2;
	}
	
	function setSlider() 
	{
		slider.x = sliderBg.x - slider.width / 2 + value * sliderBg.width;
		sliderEnd.y = sliderBg.y + (sliderBg.height - sliderEnd.height) / 2;
		slider.y = sliderBg.y + sliderBg.height / 2;
		sliderEnd.x = slider.x + (slider.width - sliderEnd.width) / 2;
	}
}