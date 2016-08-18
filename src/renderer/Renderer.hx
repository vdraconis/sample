package renderer;

import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display3D.Program3D;
import openfl.display3D.textures.Texture;
import openfl.geom.Matrix;
import renderer.BatchGeometry;
import renderer.ProjectionMatrix;
import swfdata.ColorData;
import swfdata.atlas.GLSubTexture;

class Renderer
{
	private static var HELPER_BUFFER:Vector<Float> = new Vector<Float>(16, true);
	
	var shaderProgramm:Program3D;
	
	var context3D:Context3D;
	var drawingGeometry:BatchGeometry = new BatchGeometry(1);
	
	var texturesDrawList:Vector<GLSubTexture> = new Vector<GLSubTexture>(200000, true);
	var texturesListSize:Int = 0;
	
	var drawingList:Vector<Float> = new Vector<Float>(200000, true);
	var drawingListSize:Int = 0;
	
	var projection:ProjectionMatrix = new ProjectionMatrix().ortho(800, 800, null);
	
	var currentTexture:Texture = null;

	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		
		drawingGeometry.uploadToGpu(context3D);
		shaderProgramm = new BaseAgalShader().makePrgoram(context3D);
		
		drawingList.concat(projection.rawData);
		
		context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
	}
	
	private function setTexture(texture:Texture)
	{
		if (currentTexture == texture)
			return;
			
		currentTexture = texture;
		context3D.setTextureAt(0, currentTexture);
	}
	
	public function begin()
	{
		context3D.clear();
		currentTexture = null;
		
		context3D.setProgram(shaderProgramm);
		drawingGeometry.setToContext(context3D);
		context3D.setSamplerStateAt(0, Context3DWrapMode.REPEAT, Context3DTextureFilter.LINEAR, Context3DMipFilter.MIPNONE);
		context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
	}
	
	public function render()
	{
		__draw();
		drawingListSize = 0;
		texturesListSize = 0;
	}
	
	public function end():Void
	{
		context3D.present();
	}
	
	public function drawRawTexture(texture:GLSubTexture, data:Vector<Float>) 
	{
		texturesDrawList[texturesListSize++] = texture;
		
		drawingList[drawingListSize++] = data[0];
		drawingList[drawingListSize++] = data[1];
		drawingList[drawingListSize++] = data[2];
		drawingList[drawingListSize++] = data[3];
		
		drawingList[drawingListSize++] = data[4];
		drawingList[drawingListSize++] = data[5];
		drawingList[drawingListSize++] = data[6];
		drawingList[drawingListSize++] = data[7];
		
		drawingList[drawingListSize++] = data[8];
		drawingList[drawingListSize++] = data[9];
		drawingList[drawingListSize++] = data[10];
		drawingList[drawingListSize++] = data[11];
		
		drawingList[drawingListSize++] = data[12];
		drawingList[drawingListSize++] = data[13];
		drawingList[drawingListSize++] = data[14];
		drawingList[drawingListSize++] = data[15];
	}

	public function draw(texture:GLSubTexture, matrix:Matrix, colorData:ColorData = null)
	{
		texturesDrawList[texturesListSize++] = texture;
		
		var a:Float = matrix.a;
		var b:Float = matrix.b;
		var c:Float = matrix.c;
		var d:Float = matrix.d;
		var tx:Float = matrix.tx;
		var ty:Float = matrix.ty;
		
		var pivotX:Float = texture.pivotX;
		var pivotY:Float = texture.pivotY;
		
		if (pivotX != 0 || pivotY != 0) 
		{
			tx = tx - pivotX * a - pivotY * c;
			ty = ty - pivotX * b - pivotY * d;
		}
		
		drawingList[drawingListSize++] = a;
		drawingList[drawingListSize++] = c;
		drawingList[drawingListSize++] = b;
		drawingList[drawingListSize++] = d;
		
		drawingList[drawingListSize++] = tx;
		drawingList[drawingListSize++] = ty;
		drawingList[drawingListSize++] = texture.width;
		drawingList[drawingListSize++] = texture.height;
		
		drawingList[drawingListSize++] = texture.u;
		drawingList[drawingListSize++] = texture.v;
		drawingList[drawingListSize++] = texture.uscale;
		drawingList[drawingListSize++] = texture.vscale;
		
		drawingList[drawingListSize++] = colorData.r;
		drawingList[drawingListSize++] = colorData.g;
		drawingList[drawingListSize++] = colorData.b;
		drawingList[drawingListSize++] = colorData.a;
	}
	
	@:access(swfdata)
	private function __draw()
	{
		//context3D.setCulling(Context3DTriangleFace.NONE);
		
		var quadsNum:Int = Std.int(drawingListSize / 16);
		
		//var r:Float = 0.7;
		//var g:Float = 0.5;
		//var b:Float = 0.3;
		
		//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, [r, g, b, 0.5], 1);

		for (i in 0...quadsNum)
		{
			var currentTexture:Texture = texturesDrawList[i]._atlas.gpuData;
			setTexture(currentTexture);
			
			var offset:Int = Std.int(i * 16);
			
			HELPER_BUFFER[0] = drawingList[0 + offset];
			HELPER_BUFFER[1] = drawingList[1 + offset];
			HELPER_BUFFER[2] = drawingList[2 + offset];
			HELPER_BUFFER[3] = drawingList[3 + offset];
			HELPER_BUFFER[4] = drawingList[4 + offset];
			HELPER_BUFFER[5] = drawingList[5 + offset];
			HELPER_BUFFER[6] = drawingList[6 + offset];
			HELPER_BUFFER[7] = drawingList[7 + offset];
			HELPER_BUFFER[8] = drawingList[8 + offset];
			HELPER_BUFFER[9] = drawingList[9 + offset];
			HELPER_BUFFER[10] = drawingList[10 + offset];
			HELPER_BUFFER[11] = drawingList[11 + offset];
			HELPER_BUFFER[12] = drawingList[12 + offset];
			HELPER_BUFFER[13] = drawingList[13 + offset];
			HELPER_BUFFER[14] = drawingList[14 + offset];
			HELPER_BUFFER[15] = drawingList[15 + offset];
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, HELPER_BUFFER, 4);
			context3D.drawTriangles(drawingGeometry.indexBuffer);
			
		}
	}
}