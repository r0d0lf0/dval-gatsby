package engine{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import managers.ScreenManager;

	dynamic public class SplashScreen extends MovieClip {
		
		public function SplashScreen():void {
			//check for flash spacetime coordinates
			if (stage != null) {
				buildDisplay();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		//on stage
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildDisplay();
		}
		//Now we can go about our daily business of adding button handlers.
		//this is everything we would normally do.
		private function buildDisplay() {
			this.addEventListener(MouseEvent.CLICK, buttonHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		//All button actions
		private function buttonHandler(mevt:MouseEvent):void {
			trace(mevt.target);
			switch(mevt.target.name){
				case 'start_btn':
					ScreenManager.setScreen('lvl1_map1');
					break;
				default:
					trace('doh!');
					break;
			}
		}
		//houseKeeping funciton
		private function removedFromStage(evt) {
			this.removeEventListener(MouseEvent.CLICK, buttonHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
	}//end class
}//end package