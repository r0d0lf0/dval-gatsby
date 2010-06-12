package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
    import engine.actors.player.Hero;
    import engine.IObserver;
    
	dynamic public class Map extends MovieClip {
		
		public var observerArray:Array = new Array();
		public var subjectArray:Array = new Array();
		public var objectArray:Array = new Array();
		//public var game:MovieClip;
		//private var hero:Hero;
		
		public function Map():void {
			//trace("game loaded");
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
				if(myChild is ISubject) {
				    subjectArray.push(myChild);
				}
				if(myChild is IObserver) {
				    observerArray.push(myChild);
				}
				objectArray.push(this.getChildAt(n));
			}
			
			for(var i=0; i<observerArray.length; i++) {
			    for(var s=0; s<subjectArray.length; s++) {
			        subjectArray[s].addObserver(observerArray[i]);
			    }
			}
			
			//move to bottom screen of map
			//this.y = 0-(this.height - (game.screenHeight*2));
			trace("objects referenced.");
		}
		
		private function updateSubjects():void {
		    for(var i=0; i<subjectArray.length; i++) {
		        subjectArray[i].update();
		    }
		}
		
		public function update():Boolean {
		    updateSubjects();
		    return true;
		}
	}
}