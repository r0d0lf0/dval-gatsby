package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
    import engine.actors.player.Hero;
    import engine.actors.IObserver;
    
	dynamic public class Map extends MovieClip {
		
		public var objectArray:Array = new Array();
		public var game:MovieClip;
		private var hero:Hero;
		
		public function Map(game:*=null, hero:*=null):void {
			//trace("game loaded");
			this.game = game;
			this.hero = hero;
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
				objectArray.push(this.getChildAt(n));
				
				var myChild = this.getChildAt(n);
				if(myChild is IObserver) {
				   // hero.subscribeObserver(myChild);
				}
			}
			//move to bottom screen of map
			//this.y = 0-(this.height - (game.screenHeight*2));
			trace("objects constructed.");
		}
	}
}