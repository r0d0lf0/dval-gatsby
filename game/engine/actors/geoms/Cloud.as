package engine.actors.geoms {
	
	import flash.display.DisplayObject;
	import engine.actors.MapObject;
	import engine.actors.Actor;
	import engine.IObserver;

	public class Cloud extends Actor implements IObserver {
	    
	    private var frameDelay:int = 2;
	    private var frameCounter:int = 0;
	    private var rightBoundary;
	    private var bottomBoundary;
		
		public function Cloud():void{
			super();
			rightBoundary = this.x + this.width;
			bottomBoundary = this.y + this.height;
		}
		
		public function behave(smackData:Object,characterObject:*):void{	
			var dy = smackData.dy;
			//only stop downward movement
			if(characterObject.y < me.y+(this.height/2)){
				if(dy > 0){
					characterObject.y = me.y;
					characterObject.vely = 0;
					characterObject.imon = true;
				}
			}
		}
		
		override public function checkCollision(subject) {
		    /*
		    if(subject.x >= this.x && subject.x <= (this.x+this.width)) {
		        if(subject.y >= this.y && subject.y <= (this.y+this.height)) {
		            return true;
		        }
		    }*/
		    var sl = subject.x + (subject.width / 4); // subject left boundary
		    var sr = subject.x + (subject.width - (subject.width / 4));  // subject right boundary
		    var st = subject.y - subject.height; // subject top boundary
		    var sb = subject.y;  // subject bottom boundary
		    
		    var lb = this.x; // this left boundary
		    var rb = this.x + this.width;  // this right boundary
		    var tb = this.y; // this top boundary
		    var bb = this.y + this.height;  // this bottom boundary
		    
		    if((sr >= lb && sr <= rb) || (sl <= rb && sl >= lb)) {
	            if((sb >= tb && sb <= bb)) {
                    return true;
	            }
		    }
		}
		
		public function notify(subject:*):void {
		    if(checkCollision(subject)) {
		        subject.collide(this);
		    }
		}
	}
}