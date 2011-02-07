package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
    import engine.actors.player.Hero;
    
    public class EnemyFlyer extends EnemyWalker {
        
        public var flySpeed = 4;
	public var flyingStarted = false; // this flips when the bird reaches the hero's height
	public var maxHeroProximity = 140; // how many pixels from the hero before we trigger
	public var heroTriggered = false;
	public var xPos = 0;
	public var yPos = 0;
	public var triggerHeight = 64;

        public function EnemyFlyer() {
	    trace("EnemyFlyer");
        }

        override public function collide(observer, ...args) {
	    if(observer is Hero && !deadFlag) {
	        observer.receiveDamage(this); // otherwise, if we've hit the hero, make him regret it
	    }
	}
        
        public override function moveMe():void {
	    if(flyingStarted) {
		velx = -flySpeed;
		frameCount++;
		if(frameCount >= frameDelay) { 
		    frameStarted = true;
		    statusSet = false;
		    this.x += velx / 2; // update our x variable
		    notifyObservers(); // tell everybody where we are now
		    updateStatus(); // update our status
		    frameCount = 0;
		    frameStarted = false;
		 }
	     } else if(!heroTriggered && heroInRange()) {
		 heroTriggered = true;
	     } else if(heroTriggered) {
		 dropDown();
	     }
	     
	     animate();

	}

	public function heroInRange() {
	    if(myMap.getHero()) {
		var myHero = myMap.getHero();
		if(Math.abs(this.x - myHero.x) < maxHeroProximity) {
		    return true;
		}
		return false;
	    } 
	}

	public function dropDown() {
	    var myHero = myMap.getHero();
	    triggerHeight = myHero.y;
	    if(this.y < triggerHeight) {
		if(this.y < triggerHeight / 2) {
		    this.y += 2;
		} else {
		    this.y++;
		}		
	    } else {
		flyingStarted = true;
	    }
	}
    }
    
}