package core.external.keyboard;

import haxe.Constraints.Function;
import openfl.Vector;

class KeyboardListenersList
{
	private var listsStore:Map<Int, Vector<Function>> = new Map<Int, Vector<Function>>();

	public function new()
	{

	}

	public function getListenersList(listenerIdent:Int):Vector<Function>
	{
		return listsStore.get(listenerIdent);
	}

	public function registerListener(listenerIdent:Int, listener:Function):Void
	{
		var currentList:Vector<Function> = listsStore.get(listenerIdent);
		
		if (currentList == null)
		{
			currentList = new Vector<Function>();
			listsStore.set(listenerIdent, currentList);
		}
		
		currentList.push(listener);
	}

	public function unregisterListener(listenerIdent:Int, listener:Function):Void
	{
		var currentList:Vector<Function> = listsStore.get(listenerIdent);
		
		if (currentList != null)
		{
			var index:Int = currentList.indexOf(listener);
			
			if (index != -1)
				currentList.splice(index, 1);
		}
	}
}