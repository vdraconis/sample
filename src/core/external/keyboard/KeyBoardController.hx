package core.external.keyboard;

import core.external.keyboard.KeyboardListenersList;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import haxe.Constraints.Function;
import openfl.Vector;

class KeyBoardController
{
    private var keyDownListeners:KeyboardListenersList;
    private var keyUpListeners:KeyboardListenersList;
    
    private var passedKeys:Map<Int, Bool>;
    private var preventedKeys:Map<Int, Bool>;
    
    private var stage:Stage;
    
    public function new(stage:Stage)
    {
        this.stage = stage;
        
        initilize();
    }
    
    public function isKeysDown():Bool
    {
       return passedKeys.keys().hasNext();
    }
    
    public function isKeyDown(code:Int):Bool
    {
        return passedKeys.get(code);
    }
    
    private function initilize():Void
    {
        passedKeys = new Map<Int, Bool>();
        preventedKeys = new Map<Int, Bool>();
        
        keyDownListeners = new KeyboardListenersList();
        keyUpListeners = new KeyboardListenersList();
        
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    public function destroy() : Void
    {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    private function prevent(e : KeyboardEvent) : Void
    {
        if (preventedKeys.exists(e.keyCode))
            e.preventDefault();
    }
    
    private function onKeyUp(e:KeyboardEvent):Void
    {
        var code:Int = e.keyCode;
        
        passedKeys.remove(code);
        
        prevent(e);
        
        var listeners:Vector<Function> = keyUpListeners.getListenersList(code);
        
        if (listeners != null)
        {
            for (listener in listeners)
            {
                listener();
            }
        }
    }
    
    private function onKeyDown(e : KeyboardEvent) : Void
    {
        var code : Int = e.keyCode;
        prevent(e);
        
        if (passedKeys.exists(code))
        {
            return;
        }
        else
        {
            passedKeys.set(code, true);
            
           var listeners:Vector<Function> = keyDownListeners.getListenersList(code);
        
			if (listeners != null)
			{
				for (listener in listeners)
                {
                    listener();
                }
            }
        }
    }
    
    public function registerPreventKey(key:Int):Void
    {
        preventedKeys.set(key, true);
    }
    
    public function unregisterPreventKey(key:Int):Void
    {
        if (preventedKeys.exists(key) == false)
        {
            preventedKeys.remove(key);
        }
    }
    
    public function registerKeyDownReaction(key : Int, reaction : Function) : Void
    {
        keyDownListeners.registerListener(key, reaction);
    }
    
    public function unregisterKeyDownReaction(key : Int, reaction : Function) : Void
    {
        keyDownListeners.unregisterListener(key, reaction);
    }
    
    public function registerKeyUpReaction(key : Int, reaction : Function) : Void
    {
        keyUpListeners.registerListener(key, reaction);
    }
    
    public function unregiterKeyUpReaction(key : Int, reaction : Function) : Void
    {
        keyUpListeners.unregisterListener(key, reaction);
    }
}

