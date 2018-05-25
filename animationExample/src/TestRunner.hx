package;

import fastbytearray.ByteArrayTest;


class TestRunner
{

	public function new()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new ByteArrayTest());
		
		r.run();
		

	}
	
}