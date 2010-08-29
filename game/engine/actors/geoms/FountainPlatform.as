package engine.actors.geoms {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.Animatable;
    import engine.actors.geoms.*;
    import flash.events.Event;
    
    public class FountainPlatform extends Animatable implements ISubject, IObserver {
		
        public var velocity = 1;
        private var myParent;
        private var convertedMe;
        private var oldX;
        private var oldY;
	
		public function FountainPlatform() {
		    trace("I'm a fountain platform!");
		}
		
		override public function setup() {
		    tilesWide = 1;
    		tilesTall = 7;
    		
    		oldX = this.x;
    		oldY = this.y;
		    
		    mySkin = "FountainSkin";
		    myName = "FountainPlatform";
		    startFrame = 0; // the first frame to loop on
            endFrame = 2; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
            
            convertedMe = this;
		}
		
        private function convertCoords() {
            oldX = this.x;
            oldY = this.y;

            this.x = this.x + parent.x;
            this.y = this.y + parent.y;
            
        }
        
        private function revertCoords() {
            this.x = oldX;
            this.y = oldY;
        }
        
        override public function checkCollision(subject) {
            return this.hitTestObject(subject);
        }
		
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
                subject.collide(this);
            }
		}
		
		override public function update():void {
		    animate();
		    trace("P: " + this.y);
		    if(this.y < 50) {
		        velocity = 1;
		    } else if(this.y > 140) {
		        velocity = -1;
		    }
		    this.y += velocity;
		}
	}
}