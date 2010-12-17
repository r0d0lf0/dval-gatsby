package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
    
    public class EnemyFlyer extends EnemyWalker {
        
        public var flySpeed = 3;
        
        public function EnemyFlyer() {
		    trace("EnemyFlyer");
        }

        override public function collide(observer, ...args) {
			if(observer is Hero && !deadFlag) {
		        observer.receiveDamage(this); // otherwise, if we've hit the hero, make him regret it
		    }
		}
        
        public override function moveMe():void {
            velx = -flySpeed;
		    if(frameCount >= frameDelay) { 
    			frameStarted = true;
				statusSet = false;

    			this.x += velx / 2; // update our x variable
    			
    			if(velx > 0) {
    			    this.x = Math.ceil(this.x);
    			} else {
    			    this.x = Math.floor(this.x);
    			}
    			
    			if(vely > 0) {
    			    this.y = Math.ceil(this.y);
    			} else {
    			    this.y = Math.floor(this.y);
    			}
    			
    			notifyObservers(); // tell everybody where we are now
    			updateStatus(); // update our status
                frameCount = 0;
				frameStarted = false;
		    }
		    animate();
		}

    }
    
}