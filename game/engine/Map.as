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
		    // loop through all the child objects attached to this library item, and put
		    // references to them into a local array
			for(var n=0; n<this.numChildren; n++){
				//trace(this.getChildAt(n));
				var myChild = this.getChildAt(n);
				if(myChild.object_type == "interactive") {
				    myChild.setLdr(game);
				}
				objectArray.push(myChild);
			}
			//move to bottom screen of map
			//this.y = 0-(this.height - (game.screenHeight*2));
			trace("objects constructed.");
		}
	}
}