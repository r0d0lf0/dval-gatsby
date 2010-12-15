package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
    
    public class EnemyCrab extends EnemyWalker {
	
		override public function moveMe():void {
		    if(frameCount >= frameDelay) { 
    			frameStarted = true;
				statusSet = false;
				
				var dirChange = Math.floor(Math.random() * 20);
				if(dirChange == 5) {
					velx *= -1;
				}

		        this.y += vely; // update our y variable
    			this.x += velx; // update our x variable
    			
    			notifyObservers(); // tell everybody where we are now
    			applyPhysics(); // apply our enviromental variables
    			updateStatus(); // update our status
                frameCount = 0;
				frameStarted = false;
		    } else {
		        frameCount++;
		    }
		    animate();
		}
		
		override public function setup() {
		    
			collide_left = 1; // what pixel do we collide on on the left
    		collide_right = 15; // what pixel do we collide on on the right

			collide_left_ground = 15;
			collide_right_ground = 1;
    		
    		myName = "EnemyCrab"; // the generic name of our enemy
            mySkin = "CrabSkin"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance 

			walkSpeed = .5; // 1>>.5
			velx = walkSpeed;

			tilesWide = 2;
			tilesTall = 1;
		}
        
    }
    
}