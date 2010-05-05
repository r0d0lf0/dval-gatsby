package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import engine.actors.MapObject;


	dynamic public class Map extends MovieClip {
		
		public var objectArray:Array = new Array();
		public var lvlLoader:MovieClip;
		
		public function Map(ldr:*=null):void {
			//trace("game loaded");
			this.lvlLoader = ldr;
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
		public function buildMap():void {
			for(var n=0; n<this.numChildren; n++){
				//trace(this.getChildAt(n));
				objectArray.push(this.getChildAt(n));
			}
		}
	}
}