////////////////////////////////////////////////////////////////////////////////
// File Description
////////////////////////////////////////////////////////////////////////////////
package {
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	* Class description.
	* 
	*/
	public class KeyMapping extends Sprite {

		public var keyMap:Array=new Array();
		/**
		* Constructor description.
		* 
		* @param setVars String to test.
		* Default is "HelloWorld".
		*
		* @return void Returns nothing.
		*/
		public function KeyMapping():void {

			// map control keys
			keyMap[32]=false; //SPACEBAR
			keyMap[37]=false; //LEFT
			keyMap[38]=false; //UP
			keyMap[39]=false; //RIGHT
			keyMap[40]=false; //DOWN
			keyMap[65]=false; //a
			keyMap[87]=false; //w
			keyMap[83]=false; //s
			keyMap[68]=false; //d
			
			keyMap[87]=false; //q
			keyMap[83]=false; //e
			keyMap[90]=false; //z
			keyMap[67]=false; //c
			keyMap[88]=false; //x
			
			keyMap[17]=false; //CTRL
			//keyMap[??]=false; //ALT
			if(stage){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				trace('added from construct');
			}else{
				addEventListener(Event.ADDED_TO_STAGE,subInit);
			}
			
		}
		
		private function subInit(evt:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				trace('added from subConstruct');
		}


		// swaped for key polling class
		public function keyDownHandler(evt:KeyboardEvent):void {
			keyMap[evt.keyCode]=true;
		}

		// swap for key polling class
		public function keyUpHandler(evt:KeyboardEvent):void {
			keyMap[evt.keyCode]=false;
		}
	}
}