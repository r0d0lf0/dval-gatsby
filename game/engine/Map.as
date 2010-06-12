package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
    import engine.actors.player.Hero;
    import engine.IObserver;
    
	dynamic public class Map extends MovieClip implements IObserver {
		
		public var observerArray:Array = new Array();
		public var subjectArray:Array = new Array();
		public var objectArray:Array = new Array();
		
		private var screenPadding:Number = 20;
		private var screenWidth:Number = 256;
		private var screenHeight:Number = 208;
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
			
			
			    for(var s=0; s<subjectArray.length; s++) {
			        for(var i=0; i<observerArray.length; i++) {
			            subjectArray[s].addObserver(observerArray[i]);
			        }
			        subjectArray[s].addObserver(this);
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
		
		private function moveMap(subject):void {
		    var stageLeft = -this.x + screenPadding;
		    var stageRight = -this.x + (screenWidth - screenPadding);
		    if(subject.x < stageLeft || subject.x > stageRight) {
		       this.x = -subject.x;
		    }
		}
		
		public function notify(subject:*):void {
		    moveMap(subject);
		}
		
		public function update():Boolean {
		    updateSubjects();
		    return true;
		}
	}
}