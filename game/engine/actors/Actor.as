package engine.actors{

	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;
	

	dynamic public class Actor extends MovieClip {

		protected var me:Point = localToGlobal(new Point(0,0));
		private var actor:*;
		private var ldr;
		
		private var lb:Number; // left boundary
		private var rb:Number; // right boundary
		private var tb:Number; // top boundary
		private var bb:Number; // left boundary
		
		//so nice
		public function Actor():void {
			//Check we exist in Flash spacetime
			if (stage != null) {
				buildObject();
			} else {  
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildObject();
		}
		//initialize object after it's on stage
		public function buildObject():void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		//clean up and free resources
		public function onRemove(evt:Event):void{
			//this.removeEventListener(Event.ENTER_FRAME, onFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function checkCollision(subject) {
		    /*
		    if(subject.x >= this.x && subject.x <= (this.x+this.width)) {
		        if(subject.y >= this.y && subject.y <= (this.y+this.height)) {
		            return true;
		        }
		    }*/
		    var sl = subject.x + (subject.width * .25); // subject left boundary
		    var sr = subject.x + (subject.width * .75);  // subject right boundary
		    var st = subject.y; // subject top boundary
		    var sb = subject.y + subject.height;  // subject bottom boundary
		    
		    var lb = this.x + (this.width * .25); // this left boundary
		    var rb = this.x + (this.width * .75);  // this right boundary
		    var tb = this.y; // this top boundary
		    var bb = this.y + this.height;  // this bottom boundary
		    
		    if((sr >= lb && sr <= rb) || (sl <= rb && sl >= lb)) {
	            if((sb >= tb && sb <= bb) || (st <= bb && st >= tb)) {
                    return true;
	            }
		    }
		}
		
		//show the background image
		public function textureLoadSuccess(evt:*):void {
			var tmpData:BitmapData = evt.target.content.bitmapData;
			var tmp:Bitmap = new Bitmap(tmpData);
			//tmp.scaleX = 2;
			//tmp.scaleY = 2;
			this.addChild(tmp);
		}
		//show blank
		public function textureLoadFail(evt:*=null):void {
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),true,0x00FFFFFF);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		
	}
}
