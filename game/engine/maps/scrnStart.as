package engine.maps{

	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;

	  dynamic public class scrnStart extends Map {
		//load game vars into 'global' memory
		
		public function scrnStart(ldr:*=null):void {
			//sets lvlLoader
			super(ldr);
			//check for flash spacetime coordinates
			if (stage != null) {
				buildDisplay();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildDisplay();
		}
		//Now we can go about our daily business of adding button handlers.
		//this is everything we would normally do.
		private function buildDisplay() {
			start_btn.addEventListener(MouseEvent.CLICK, startHandler);
		}
		//Start button actions
		private function startHandler(mevt:MouseEvent):void {
			//remove vaccant listeners
			start_btn.removeEventListener(MouseEvent.CLICK, startHandler);
			//load level 1_1
			lvlLoader.loadLevel(new lvl1_1(lvlLoader));
			//remove start screen
			parent.removeChild(this);
		}
	}//end class
}//end package