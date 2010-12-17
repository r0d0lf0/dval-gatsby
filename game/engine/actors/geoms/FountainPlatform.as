package engine.actors.geoms {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.Animatable;
    import engine.actors.geoms.*;
    import flash.events.Event;
    
    public class FountainPlatform extends Animatable implements ISubject, IObserver {
		
        public var liftSpeed = 1; // how quickly should the fountain move
        public var velocity = liftSpeed;
        private var myParent;
        private var convertedMe;
        private var oldX;
        private var oldY;
		public var convertedX;
		public var convertedY;
	
		public function FountainPlatform() {
			
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
            speed = 10; // 5 replaced // how many frames should go by before we advance
            
            convertedMe = this;
		}
		
        private function convertCoords() {
			convertedX = this.x + parent.x;
            convertedY = this.y + parent.y;
        }
        
        private function revertCoords() {
            this.x = oldX;
            this.y = oldY;
        }
        
        override public function checkCollision(subject) {
			convertCoords();
            return this.hitTestObject(subject);
        }
		
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
				if((subject.x + subject.collide_right_ground) > convertedX && (subject.x + subject.collide_left_ground) < convertedX + this.width) {
	                subject.collide(this);
				}
            }
		}
		
		override public function update():void {
		    animate();
		    if(this.y < 80) {
		        velocity = liftSpeed;
		    } else if(this.y > 130) {
		        velocity = -liftSpeed;
		    }
		    this.y += velocity;
		}
	}
}