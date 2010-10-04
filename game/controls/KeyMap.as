//
package controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import engine.ISubject;
	
	dynamic public class KeyMap extends Sprite implements ISubject {
		
		static public var _keyMap:Array=new Array();
		private static var _instance:KeyMap=null;
		public static const KEY_DOWN:String = KeyboardEvent.KEY_DOWN;
		public static const KEY_UP:String = KeyboardEvent.KEY_UP;
		private static var last_key_pressed:int = 0;
		private var observers:Array = new Array();
		
		public function KeyMap(e:SingletonEnforcer):void {
			// map control keys
			_keyMap[32]=false; //SPACEBAR
			_keyMap[37]=false; //LEFT
			_keyMap[38]=false; //UP
			_keyMap[39]=false; //RIGHT
			_keyMap[40]=false; //DOWN
			_keyMap[65]=false; //a
			_keyMap[87]=false; //w
			_keyMap[83]=false; //s
			_keyMap[68]=false; //d
			
			_keyMap[81]=false; //q
			_keyMap[69]=false; //e
			_keyMap[90]=false; //z
			_keyMap[67]=false; //c
			_keyMap[88]=false; //x
			_keyMap[90]=false; //z
			
			_keyMap[17]=false; //CTRL
			//keyMap[Keyboard]=false; //ALT
			
			//where in the spacetime are we, with regards to Stage
			if(stage != null){
				if(!stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
				buildKeys();
				}
			}else{
				addEventListener(Event.ADDED_TO_STAGE,subInit);
			}
		}
		
		public static function getInstance():KeyMap{
            if(_instance==null){
                _instance=new KeyMap(new SingletonEnforcer());
            }
            return _instance;
        }
		
		//load listeners after stage is loaded
		private function subInit(evt:Event):void{
			buildKeys();
			removeEventListener(Event.ADDED_TO_STAGE,subInit);
		}
		//
		private function buildKeys():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		// onKeyDown set array item True, broadcast event
		public function keyDownHandler(evt:KeyboardEvent):void {
			_keyMap[evt.keyCode]=true;
			last_key_pressed = evt.keyCode;
			dispatchEvent(new Event(KEY_DOWN));
			notifyObservers();
		}
		// onKeyUp set same item False
		public function keyUpHandler(evt:KeyboardEvent):void {
			_keyMap[evt.keyCode]=false;
			dispatchEvent(new Event(KEY_UP));
			notifyObservers();
		}
		// return reference to array
		public static function get keyMap():Array{
			return _keyMap;
		}
		
		static public function getLastKey():int {
		    return last_key_pressed;
		}
		//check if any keys are pressed. (helper function)
		static public function chkeys():Boolean {
			var tmp:Boolean = false;
			for(var i:String in KeyMap.keyMap){
				if(KeyMap.keyMap[i]){tmp = true;}
			}
			return tmp;
		}
		
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		public function isObserver(observer):Boolean {
		    for(var ob:int=0; ob<observers.length; ob++) {
		        if(observers[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice(ob,1);
                    break;
                }
            }
		}
		
	    public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
	}
}

//I’m outside the package so I can only be access internally
class SingletonEnforcer{
//nothing else required here
}