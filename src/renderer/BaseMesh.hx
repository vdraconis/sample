package renderer;

import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;

class BaseMesh
{
	public var vertexDataRaw:Array<Float> = new Array<Float>();
	public var uvDataRaw:Array<Float> = new Array<Float>();
	public var indexDataRaw:Array<UInt> = new Array<UInt>();
	
	public var vertexBuffer:VertexBuffer3D;
	public var uvBuffer:VertexBuffer3D;
	public var indexBuffer:IndexBuffer3D;
	
	public function new() 
	{
		
	}
	
	public function uploadToGpu(context3D:Context3D):Void
	{
		var verticesCount:Int = Std.int(vertexDataRaw.length / 3);
		
		if (vertexBuffer == null)
			vertexBuffer = context3D.createVertexBuffer(verticesCount, 3);
			
		vertexBuffer.uploadFromVector(vertexDataRaw, 0, verticesCount);
		
		if (uvBuffer == null)
			uvBuffer = context3D.createVertexBuffer(verticesCount, 2);
			
		uvBuffer.uploadFromVector(uvDataRaw, 0, verticesCount);
		
		if (indexBuffer == null)
			indexBuffer = context3D.createIndexBuffer(indexDataRaw.length);
			
		indexBuffer.uploadFromVector(indexDataRaw, 0, indexDataRaw.length);
	}
}