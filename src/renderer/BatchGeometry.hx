package renderer;

import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.VertexBuffer3D;
import openfl.display3D.Context3D;

class BatchGeometry extends BaseMesh
{
	public var orderBufferDataRaw:Array<Float> = new Array<Float>();
	
	public var orderBuffer:VertexBuffer3D;
	
	public function new(batchSize:Int) 
	{
		super();
		
		var vertexDataIndex:Int = 0;
		var uvDataIndex:Int = 0;
		var indexDataIndex:Int = 0;
		var orderDataIndex:Int = 0;
		var order:Float = 0;
			
		for (i in 0...batchSize)
		{
			vertexDataRaw[vertexDataIndex++] = -0.5;	vertexDataRaw[vertexDataIndex++] =  0.5;	vertexDataRaw[vertexDataIndex++] = 0.5;
			vertexDataRaw[vertexDataIndex++] = -0.5;	vertexDataRaw[vertexDataIndex++] = -0.5;	vertexDataRaw[vertexDataIndex++] = 0.5;
			vertexDataRaw[vertexDataIndex++] =  0.5;	vertexDataRaw[vertexDataIndex++] = -0.5;	vertexDataRaw[vertexDataIndex++] = 0.5;
			vertexDataRaw[vertexDataIndex++] =  0.5;	vertexDataRaw[vertexDataIndex++] =  0.5;	vertexDataRaw[vertexDataIndex++] = 0.5;
			
			uvDataRaw[uvDataIndex++] = 0;	uvDataRaw[uvDataIndex++] = 1;
			uvDataRaw[uvDataIndex++] = 0;	uvDataRaw[uvDataIndex++] = 0;
			uvDataRaw[uvDataIndex++] = 1;	uvDataRaw[uvDataIndex++] = 0;
			uvDataRaw[uvDataIndex++] = 1;	uvDataRaw[uvDataIndex++] = 1;
			
			indexDataRaw[indexDataIndex++] = 4 * i;	indexDataRaw[indexDataIndex++] = 4 * i + 1;	indexDataRaw[indexDataIndex++] = 4 * i + 2;
			indexDataRaw[indexDataIndex++] = 4 * i;	indexDataRaw[indexDataIndex++] = 4 * i + 2;	indexDataRaw[indexDataIndex++] = 4 * i + 3;
			
			order = 4 + (i * 4);
			
			orderBufferDataRaw[orderDataIndex++] = order;	//orderBufferDataRaw[orderDataIndex++] = order;
			orderBufferDataRaw[orderDataIndex++] = order;	//orderBufferDataRaw[orderDataIndex++] = order;
			orderBufferDataRaw[orderDataIndex++] = order;	//orderBufferDataRaw[orderDataIndex++] = order;
			orderBufferDataRaw[orderDataIndex++] = order;	//orderBufferDataRaw[orderDataIndex++] = order;
		}
	}
	
	override public function uploadToGpu(context3D:Context3D):Void 
	{
		super.uploadToGpu(context3D);
		
		var verticesCount:Int = Std.int(vertexDataRaw.length / 3);
		
		if (orderBuffer == null)
			orderBuffer = context3D.createVertexBuffer(verticesCount, 1);
		
		orderBuffer.uploadFromVector(orderBufferDataRaw, 0, verticesCount); 
	}
	
	public function setToContext(context3D:Context3D) 
	{
		context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		context3D.setVertexBufferAt(2, orderBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
	}
}