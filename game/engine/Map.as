//////////////////////////////////////////////////////////
//Modify this somehow to alternately load textures.
// i.e. I should be able to load all brush shapes as white geoms,
// or I should be able to load them as mapped textures.
//Secondly, scale should be adjustable. Then I can load an
// untextured, smaller version into the navigation panel. maybe
// also use this for some level effects, like:
// 'drink me -> shrink', 'eat me -> grow'
// 
package engine{

	import flash.events.Event;
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import engine.actors.MapObject;
	import system.ImageLoader;


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