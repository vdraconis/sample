package events;
import events.Event;
import haxe.Constraints.Function;

/**
 * @author gNikro
 */
interface IObserver 
{
  
  function addEventListener(type:String, callback:Function):Void;
  
  function dispatchEvent(event:Event):Void;
}