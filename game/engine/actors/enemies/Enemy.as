package engine.actors.enemies {
    
    import engine.actors.Animatable;
    import flash.events.Event;
    import engine.actors.player.Hero;
    import engine.actors.weapons.HatWeapon;
    
    public class Enemy extends Animatable {
        
        protected var observers:Array = new Array();
        protected var HP:Number = 1;
        protected var attack_strength:Number = 1;
        protected var deadFlag:Boolean = false;
        
        protected var mySkin:String = "GenericEnemySkin";
        protected var myName:String = "GenericEnemy";

        protected var dieSound = new enemy_die();
        protected var hitDirection = 0;
        
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
    	    setSkin(mySkin,2,2);
    	    trace(myName + " created.");
		}
		
		public function setup() {
		    // this will get overridden
		}
        
        // this should get the enterFrame tick like everything else
        override public function update():void {

        }
        
        public function addObserver(observer):void {
		    observers.push(observer);
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice(ob,1);
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
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
		    }
		    return false;
        }
        
        // the hero will use this to deal damage
        public function receiveDamage(damage:Number) {
            HP -= damage;
            if(HP <= 0) {
                HP = 0;
            }
        }

		public function notify(subject):void {
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