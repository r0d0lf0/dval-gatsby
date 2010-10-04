package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
    
    public class EnemyFlyer extends EnemyWalker {
        
        public var flySpeed = 3;
        
        public function EnemyFlyer() {
		    trace("EnemyFlyer");
        }
        
        public override function moveMe():void {
            velx = -flySpeed;
		    if(frameCount >= frameDelay) { 
    			frameStarted = true;
				statusSet = false;

    			this.x += velx; // update our x variable
    			
    			notifyObservers(); // tell everybody where we are now
    			updateStatus(); // update our status
                frameCount = 0;
				frameStarted = false;
		    }
		    animate();
		}

    }
    
}