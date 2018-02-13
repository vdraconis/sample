package renderer;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Program3D;
import openfl.utils.AGALMiniAssembler;


class BaseAgalShader
{
	static var AGALAssembler:AGALMiniAssembler = new AGALMiniAssembler(false);
	
	var vertexData:Dynamic;
	var fragmentData:Dynamic;
	
	var isCompiled:Bool = false;
	
	public function new() 
	{
		
	}
	
	public function makePrgoram(context:Context3D):Program3D
	{
		var program = context.createProgram();
		
		if (!isCompiled)
			compile();
			
		program.upload(vertexData, fragmentData);
		
		return program;
	}
	
	public function compile():Void
	{
		vertexData = AGALAssembler.assemble(Context3DProgramType.VERTEX, getVertexCode());
		fragmentData = AGALAssembler.assemble(Context3DProgramType.FRAGMENT, getFragmentCode());
	}
	
	public function getVertexCode():String
	{
		/*return 
			"mov	vt0			va0						\n"
		
		+	"mov 	vt2			vc0						\n"
		+	"mov 	vt4			vc1						\n"

		+	"mov	vt3 		va0					    \n" //VertexData meshVertexData2 = mesh;
		+	"mul	vt3.x		vt3.x		vt4.x		\n" //meshVertexData2.x *= meshRotation.rotatioX.x;
		+	"mul	vt3.y		vt3.y		vt4.y		\n" //meshVertexData2.y *= meshRotation.rotatioX.y;
		+	"sub	vt0.x		vt3.x		vt3.y		\n" //meshVertexData.x = meshVertexData2.x - meshVertexData2.y;
		
		
		+	"mov	vt3 		va0						\n" //meshVertexData2 = mesh;
		+	"mul	vt3.x		vt3.x		vt4.y		\n" //meshVertexData2.x *= meshRotation.rotatioX.y;
		+	"mul	vt3.y		vt3.y		vt4.x		\n" //meshVertexData2.y *= meshRotation.rotatioX.x;
		+	"add	vt0.y		vt3.x		vt3.y		\n" //meshVertexData.x = meshVertexData2.x + meshVertexData2.y;
		
		+	"mul	vt0.xy		vt0.xy		vc0.zz		\n"
		+	"add	vt0.xy		vt0.xy		vc0.xy		\n"
		+	"mov	op			vt0						\n"
		+	"mov	v0			va0";*/
		
		return 
			"mov vt0, va2						\n" +
			"mov vt0, va0						\n" +

            "mul vt1, va0.xy, vc5.zw      \n" +

            "mul vt2, vt1.xy, vc4.xy      \n" +
            "add vt2.x, vt2.x, vt2.y            \n" +
            "add vt2.x, vt2.x, vc5.x      \n" +

            "mul vt3, vt1.xy, vc4.zw      \n" +
            "add vt3.x, vt3.x, vt3.y            \n" +
            "add vt3.x, vt3.x, vc5.y      \n" +

            "mov vt2.y, vt3.x \n" +

			"mov vt2.zw, vt0.zw					\n" +
			
			"m44 vt3, vt2, vc0					\n" +
			
			//"mov vt3.z		va2.y				\n" +
			"mov op			vt3						\n" +

			"mul vt0.xy, va1.xy, vc6.zw	\n" +
			"add vt0.xy, vt0.xy, vc6.xy	\n" +

			"mov v0, vt0 \n"+
			"mov v1, vc7 \n"+
			"mov v2, vc8";
	}
	
	public function getFragmentCode():String
	{
		return 
				  "tex 	ft0			v0			fs0		<2d, clamp, linear>	\n"
				+ "max	ft0			ft0			fc1							\n"
				+ "div	ft0.xyz		ft0.xyz		ft0.www						\n"
				+ "mul	ft0			ft0			v1							\n"
				+ "add	ft0			ft0			v2							\n"
				+ "mul	ft0.xyz		ft0.xyz		ft0.www						\n"
				+ "sub	ft1.w		ft0.w		fc0.w						\n"
				+ "kil	ft1.w												\n"
				+ "mov	oc			ft0									  "; 
				//+	"m44	ft0			ft0			fc1						\n"  ;
	}
	
}