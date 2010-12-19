package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
    import engine.actors.player.Hero;
    
    public class EnemySailor extends EnemyWalker {
        
        private var theCounter = 0;
		
		override public function setup() {
		    collide_left = 12; // what pixel do we collide on on the left
    		collide_right = 24; // what pixel do we collide on on the right
    		
    		myName = "EnemySailor"; // the generic name of our enemy
            mySkin = "SailorSkin"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance            
		}
		
		override public function notify(subject:*):void {
		    if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
		    }
		
			if(subject is Hero) {
			    theCounter++;
			    this.alpha = theCounter % 2;
				if(subject.x < this.x) {
					goingLeft = 1;
					this.velx = -walkSpeed;
				} else {
					goingLeft = 0;
					this.velx = walkSpeed;
				}
			}
		}
        
    }
    
}