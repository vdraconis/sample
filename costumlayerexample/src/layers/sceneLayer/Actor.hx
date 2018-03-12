package layers.sceneLayer;
import motion.Actuate;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import swfdata.ColorData;
import swfdata.MovieClipData;
import swfdata.SpriteData;
import swfdata.atlas.ITextureAtlas;

class Actor
{
	
	var isInit:Bool = false;
	
	public var id:String;
	public var view:SpriteData;
	var viewMovieClipData:MovieClipData;
	
	public var alpha(get, set):Float;
	
	public var atlas:ITextureAtlas;
	
	public var position:Point = new Point();
	
	public var colorData:ColorData = new ColorData(1, 1, 1, 0.05);
	
	public var bounds:Rectangle = new Rectangle();
	
	public var isUnderMouse:Bool = false;
	
	public var visible:Bool = true;
	
	private var frame:Int = 0;
	
	public var isPlay:Bool = true;
	
	public function new(view:SpriteData, atlas:ITextureAtlas) 
	{
		this.atlas = atlas;
		this.view = view;
		
		id = view.libraryLinkage;
		
		if (Std.is(view, MovieClipData))
		{
			viewMovieClipData = cast view;
			frame = Std.int(Math.random() * viewMovieClipData.framesCount);
		}
			
		view.gotoAndPlayAll(frame);
	}
	
	public function update():Void
	{
		if (isInit == false)
		{
			isInit = true;
			alpha = 0.05;
			Actuate.tween(this, 2, { alpha:1 } ).delay(0.05);
		}
		
		if (isPlay)
		{
			if (viewMovieClipData != null)
			{
				viewMovieClipData.gotoAndStop(frame++);
				
				if (frame > viewMovieClipData.framesCount)
					frame = 0;
			}
		}
	}
	
	public function onMouseDown():Void
	{
		colorData.r = 1.7;
	}
	
	public function onMouseUp():Void
	{
		colorData.r = 1;
	}
	
	public function onRightMouseDown() 
	{
		colorData.g += 0.3;
	}
	
	public function onRightMouseUp():Void
	{
		colorData.g -= 0.3;
	}
	
	function get_alpha():Float 
	{
		return colorData.a;
	}
	
	function set_alpha(value:Float):Float 
	{
		colorData.a = value;
		
		return value;
	}
}