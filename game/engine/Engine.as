package engine{

	import flash.display.MovieClip;
	import flash.events.Event;
	import engine.Subscriber;

	dynamic public class Engine extends MovieClip{
		
		public function Engine():void {
			//check for flash spacetime coordinates
			if (stage != null) {
				start();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		//on stage
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			start();
		}
		//Now we can go about our daily business of adding button handlers.
		//this is everything we would normally do.
		public function start():void {
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			trace('doit');
		}
		
		private function onFrame(evt:Event):void{
			//trace(Subscriber.subscriptions);
			for(var i in Subscriber.subscriptions){
				Subscriber.subscriptions[i].update();
			}
		}
	}//end class
}//end package