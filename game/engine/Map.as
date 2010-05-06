package engine{

	import flash.events.Event;
	import flash.display.MovieClip;

	dynamic public class Map extends MovieClip {
		
		public var objectArray:Array = new Array();
		public var game:MovieClip;
		
		public function Map(ldr:*=null):void {
			//trace("game loaded");
			this.game = ldr;
			if (stage != null) {
				buildMap();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildMap();
		}
		private function buildMap():void {
			for(var n=0; n<this.numChildren; n++){
				//trace(this.getChildAt(n));
				objectArray.push(this.getChildAt(n));
			}
		}
	}
}