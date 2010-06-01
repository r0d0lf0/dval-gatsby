package engine.maps{

	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;

	dynamic public class scrnStart extends Map {
		
		public function scrnStart(game:*=null):void {
			//sets global reference to game
			super(game);
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
			game.newLevel(new lvl1_1(game));
		}
	}//end class
}//end package