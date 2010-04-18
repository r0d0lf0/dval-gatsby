//
package controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class KeyMap extends Sprite {
		
		private static var _keyMap:Array=new Array();
		
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
			
			_keyMap[17]=false; //CTRL
			//keyMap[??]=false; //ALT
			
			//if we havn't already assigned the key listeners...
			//where in the spacetime are we, with regards to Stage
			if(!stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
				if(stage){
					stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				}else{
					addEventListener(Event.ADDED_TO_STAGE,subInit);
				}
			}
		}
		//load listeners after stage is loaded
		private function subInit(evt:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			removeEventListener(Event.ADDED_TO_STAGE,subInit);
		}
		// onKeyDown set array item True
		public function keyDownHandler(evt:KeyboardEvent):void {
			_keyMap[evt.keyCode]=true;
		}
		// onKeyUp set same item False
		public function keyUpHandler(evt:KeyboardEvent):void {
			_keyMap[evt.keyCode]=false;
		}
		// return reference to array
		public static function get keyMap():Array{
			return _keyMap;
		}
	}
}