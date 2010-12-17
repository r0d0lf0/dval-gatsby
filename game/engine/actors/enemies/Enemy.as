package engine.actors.enemies {
    
    import engine.actors.Animatable;
    import flash.events.Event;
    import engine.actors.player.Hero;
    import engine.actors.weapons.HatWeapon;
    import engine.Scoreboard;
    
    public class Enemy extends Animatable {
        
        public var damage:Number = 1;
        public var deadFlag:Boolean = false;
        protected var dieSound = new enemy_die();
        protected var hitDirection = 0;
        protected var scoreboard:Scoreboard = Scoreboard.getInstance();
        protected var deathFrame = 1;
        
        public function Enemy() {
			if (stage != null) {
				setup();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			setup();
    	    trace(myName + " created.");
		}
        
        // this should get the enterFrame tick like everything else
        override public function update():void {

        }
        
        override public function setup() {
            mySkin = "GenericEnemySkin";
            myName = "GenericEnemy";
        }
		
		override public function collide(observer, ...args) {
            if(observer is Hero && !deadFlag) {
		        observer.receiveDamage(this); // otherwise, if we've hit the hero, make him regret it
		    }
		}
        
        public function checkDeath():Boolean {
            if(HP <= 0 && !deadFlag) {
				HP = 0;
		        dieSound.play(0);
		        deadFlag = true;
		        scoreboard.addToScore(this, points);
		        setLoop(0, deathFrame, deathFrame, deathFrame, 0);
		    }
		    return false;
        }

		override public function notify(subject):void {
		    if(checkCollision(subject) && !deadFlag) { // If i'm colliding with something, and I'm alive...
		        if(subject is HatWeapon) { // if it's the hero's weapon
		            hitDirection = subject.goingLeft; // and determine the direction from whence you were hit
		        }
            }
		}
        
    }
    
}