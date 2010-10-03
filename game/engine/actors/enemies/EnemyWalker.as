package engine.actors.enemies {
    
    import engine.actors.geoms.*;
    
    public class EnemyWalker extends Enemy {
        
        protected var frameCount:int = 0;
        protected var frameDelay:int = 0;
        
        protected var walkSpeed:Number = 1;
        protected var walkDir:int = -1;
        
        protected var groundCollide:Boolean;
        
        public function EnemyWalker() {
		    this.y -= this.height; // bring waiters up to floor
        }
        
        public function moveMe() {
            // this will get overwritten later,
            // this is to control how the guy moves around
            if(frameCount >= frameDelay) {
		        this.x += walkSpeed;
		        frameCount = 0;
		        notifyObservers();
    		    if(!groundCollide && !deadFlag) {
    		        walkSpeed *= -1;
    		        if(walkSpeed > 0) {
    		            goingLeft = 0;
    		        } else {
    		            goingLeft = 1;
    		        }
    		    }
		    } else {
		        frameCount++;
		    }
        }
        
        override public function update():void {
            moveMe();
		    animate();
            checkDeath();
		    
		    if(deadFlag) {
		       if(this.y > 240) {
                   myMap.removeFromMap(this);
		       } else {
		           setLoop(0, 2, 2, 2, 0);
    		       this.y += 2;
		       }
		    }
		    
		    groundCollide = false;
		}
        
        public function collide(subject) {
		    if(subject is Geom) {
		        if(!groundCollide) {
    		        groundCollide = true;
    		    }
		    }
		}
        
    }
    
}