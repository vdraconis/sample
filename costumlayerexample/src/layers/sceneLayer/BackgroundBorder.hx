package layers.sceneLayer;

import openfl.geom.Matrix;
import openfl.geom.Point;
import renderer.Renderer;
import swfdata.ColorData;
import swfdata.Rectagon;
import swfdata.atlas.GLSubTexture;

/**
 * Берем полигон из четырех вершин, поворачиваем его на 45 градусов и сплющиваем по горизонтали в двое
 * далее растягиваем полигон указывая его рзамер и по его бордерам ставим прямоугольники с репит-текстурой
 * 
 * @author 
 */
class BackgroundBorder 
{
	static var RAD_90:Float = Math.PI / 2;
	
	var cachedMatrices:Array<Matrix> = new Array<Matrix>();
	var matricesInvalidateFlags:Array<Bool> = new Array<Bool>();
	
	var borderRectagon:Rectagon;
	
	var texture:GLSubTexture;
	
	@:isVar
	var size(get, set):Float;
	
	var lastDeltaX:Float = 0;
	var lastDeltaY:Float = 0;
	var tile_size:Float = 34;
	
	var renderer:Renderer;
	var colorData:ColorData = new ColorData(1, 1, 1, 1.5);
	
	public function new(renderer:Renderer, texture:GLSubTexture, tile_size:Float, size:Float) 
	{
		this.renderer = renderer;
		this.tile_size = tile_size;
		//TODO: можно вообще все одной геометрией генерировать, полигоном правда в геноме это слегка упорото
		this.size = size;
		this.texture = texture;
		
		initialize();
	}
	
	private function initialize() 
	{
		cachedMatrices[0] = new Matrix();
		cachedMatrices[1] = new Matrix();
		cachedMatrices[2] = new Matrix();
		cachedMatrices[3] = new Matrix();
		
		var transform:Matrix = new Matrix();
		transform.rotate(-Math.PI / 4);
		transform.scale(1, 0.5);
		
		borderRectagon = new Rectagon( -size / 2 * tile_size, -size / 2 * tile_size, size * tile_size, size * tile_size, transform);
		
		if(size != 0)
			borderRectagon.applyTransform();
	}
	
	/**
	 * Размер в еденицах тейлах причем с учетом что тейлы квадраты, а не что то там т.е скорее всгео это будет
	 * rect.width
	 * 
	 * @param	size
	 */
	public function setSize(size:Float)
	{
		if (borderRectagon == null)
			return;
			
		borderRectagon.setTo( -size / 2 * tile_size, -size / 2 * tile_size, size * tile_size, size * tile_size);
		
		invalidateCache();
	}
	
	public function draw(deltaX:Float, deltaY:Float)
	{	
		var invalidateFlag:Bool = deltaX != lastDeltaX || deltaY != lastDeltaY; 
		
		lastDeltaX = deltaX;
		lastDeltaY = deltaY;
		
		if (invalidateFlag)
			invalidateCache();
			
		validateMatrices();
		
		drawBorder(0);
		drawBorder(1);
		drawBorder(2);
		drawBorder(3);
	}
	
	private function invalidateCache() 
	{
		matricesInvalidateFlags[0] = false;
		matricesInvalidateFlags[1] = false;
		matricesInvalidateFlags[2] = false;
		matricesInvalidateFlags[3] = false;
	}
	
	private function drawBorder(index:Int)
	{
		var drawingMatrix:Matrix = cachedMatrices[index];
		renderer.draw(texture, drawingMatrix, colorData);
		//Genome2D.g2d_instance.g2d_context.drawMatrix(texture, drawingMatrix.a, drawingMatrix.b, drawingMatrix.c, drawingMatrix.d, drawingMatrix.tx, drawingMatrix.ty);
	}
	
	private function validateMatrices()
	{
		if (matricesInvalidateFlags[0] == false)
			calculateMatrix(0, borderRectagon.resultTopLeft, 		borderRectagon.resultTopRight, 		-3);
		
		if (matricesInvalidateFlags[1] == false)
			calculateMatrix(1, borderRectagon.resultTopRight, 		borderRectagon.resultBottomRight, 	-3);
		
		if (matricesInvalidateFlags[2] == false)
			calculateMatrix(2, borderRectagon.resultBottomRight, 	borderRectagon.resultBottomLeft, 	 3);
		
		if (matricesInvalidateFlags[3] == false)
			calculateMatrix(3, borderRectagon.resultBottomLeft, 	borderRectagon.resultTopLeft, 		 3);
	}
	
	 /**
	 * Выставляет прямоугольник с текстурой правой стороной в точке А левой стороной в точке Б, растягивает до нжуных разеров и поворачивает
	 * 
	 * @param	pointA
	 * @param	pointB
	 * @param	delta - волшебный параметр чтобы уменьшить наложение текстур друг на друга в левом и правом краю. По сути нжуно было бы на углах отдельную текстуру использовать
	 */
	private function calculateMatrix(index:Int, pointA:Point, pointB:Point, delta:Float)
	{
		var distance:Float = (GeomMath.pdistance(pointA, pointB)) / tile_size;
			
		texture.uscale = distance; //не нужно отдельно хранить т.к все дистансы будут одинаковы
		
		var drawingMatrix:Matrix = cachedMatrices[index];
		
		drawingMatrix.identity();
		
		drawingMatrix.tx = -tile_size/2;
		drawingMatrix.ty = -tile_size/2;
		drawingMatrix.scale(distance, 1);
		
		var angle:Float = -FastMath.angle(pointA.x, pointA.y, pointB.x, pointB.y) + RAD_90;
		drawingMatrix.rotate(angle);
		
		drawingMatrix.tx += lastDeltaX + pointA.x;
		drawingMatrix.ty += lastDeltaY + pointA.y + delta;
		
		matricesInvalidateFlags[index] = true;
	}
	
	function get_size():Float 
	{
		return size;
	}
	
	function set_size(value:Float):Float 
	{
		setSize(value);
		return size = value;
	}
}