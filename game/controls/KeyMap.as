//
package controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	dynamic public class KeyMap extends Sprite {
		
		static public var _keyMap:Array=new Array();
		public static const KEY_DOWN:String = KeyboardEvent.KEY_DOWN;
		public static const KEY_UP:String = KeyboardEvent.KEY_UP;
		private static var last_key_pressed:int = 0;
		
		public function KeyMap():void {
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
			dispatchEvent(new Event(KEY_DOWN))
		}
		// onKeyUp set same item False
		public function keyUpHandler(evt:KeyboardEvent):void {
			_keyMap[evt.keyCode]=false;
			dispatchEvent(new Event(KEY_UP))
		}
		// return reference to array
		public static function get keyMap():Array{
			return _keyMap;
		}
		
		static public function getLastKey():int {
			//trace(last_key_pressed);
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
	}
}