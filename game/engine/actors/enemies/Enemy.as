package engine.actors.enemies {
    
    import engine.actors.Animatable;
    import flash.events.Event;
    import engine.actors.player.Hero;
    import engine.actors.weapons.HatWeapon;
    import engine.Scoreboard;
    
    public class Enemy extends Animatable {
        
        protected var attack_strength:Number = 1;
        protected var deadFlag:Boolean = false;

        protected var dieSound = new enemy_die();
        protected var hitDirection = 0;
        
        protected var points:Number = 100;
        
        protected var scoreboard:Scoreboard = Scoreboard.getInstance();
        
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
        
        // default collision methods, will probably get overwritten
        override public function checkCollision(subject) {
            if(Math.abs((subject.x + (.25 * subject.width)) - (this.x + (.25 * this.width))) <= this.width/2) {
                if(Math.abs(subject.y - this.y) <= 32) {
                    return true;
                }
            }
        }
        
        public function checkDeath():Boolean {
            if(HP <= 0 && !deadFlag) {
		        dieSound.play(0);
		        deadFlag = true;
		        scoreboard.addToScore(points);
		    }
		    return false;
        }

		override public function notify(subject):void {
		    if(checkCollision(subject) && !deadFlag) { // If i'm colliding with something, and I'm alive...
		        if(subject is Hero) {
		            subject.receiveDamage(1);
		        }
		        if(subject is HatWeapon) {
		            receiveDamage(1);
		            hitDirection = subject.goingLeft;
		        }
            }
		}
        
    }
    
}