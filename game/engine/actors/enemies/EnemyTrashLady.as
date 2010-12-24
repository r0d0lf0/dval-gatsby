package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
	import engine.actors.weapons.HatProjectile;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import engine.actors.weapons.ActorCannon;
	import utils.FlipTimer;
    
    public class EnemyTrashLady extends Enemy {
		
		private var chandelierSound = new chandelier_sound();
		private var shooting = false;
		private var shot = false;
        private var triggerDistance = 128;
        private var shootCounter = 0;
        
        private var currentMode = 1;
        private var pauseFlag = false;
        
        private var visibleFlag = false;
        
        private var myActorCannon;

		override public function setup() {
			myName = "EnemyTrashLady"; // the generic name of our enemy
	        mySkin = "TrashLadySkin"; // the name of the skin for this enemy
	        
	        collide_left = 0; // what pixel do we collide on on the left
    		collide_right = 16; // what pixel do we collide on on the right
	        
	        points = 250;

			damage = 1;
		    startFrame = 0; // the first frame to loop on
	        endFrame = 0; // the final frame in the row
	        nowFrame = 0; // current frame in row
	        loopFrame = 0; // frame at which to loop
	        loopType = 0; // 0 loops, 1 bounces
	        loopRow = 0; // which row are we on
	        loopDir = 1; // loop forward (to the right) by default
	        speed = 10; // 5 replaced // how many frames should go by before we advance

	        goingLeft = false;
	        deadFlag = false;

            tile = 8;
	        tilesWide = 2;
		    tilesTall = 3;
		    
		    myActorCannon = new ActorCannon();
			myActorCannon.setOwner(this);
			myActorCannon.setAmmoType("Trash");
			myActorCannon.vecx = 0;
			myActorCannon.vecy = 1;
			myMap.spawnActor(myActorCannon, this.x, this.y);
		}
		
		override public function collide(observer, ...args) {
            if(observer is Hero && !deadFlag && visibleFlag) {
		        observer.receiveDamage(this); // otherwise, if we've hit the hero, make him regret it
		    }
		}
		
		override public function notify(subject:*):void {
			if(subject is Hero) {
				if((Math.abs(subject.x - this.x) < triggerDistance) && !shooting) {
					shooting = true;
				}
			}
			if(subject is HatProjectile && visibleFlag) { // if it's the hero's weapon
			    if(checkCollision(subject)) {
    	            hitDirection = subject.goingLeft; // and determine the direction from whence you were hit
			    }
	        }
		}
		
		public function incrementMode() {
		    currentMode++;
		    pauseFlag = false;
		}
		
		public function shotReset() {
		    shooting = false;
		    shot = false;
		    pauseFlag = false;
		    currentMode = 1;
		}
		
		override public function update():void {
			if(!deadFlag) {
			    if(nowFrame == 2) {
			        visibleFlag = true;
			    } else {
			        visibleFlag = false;
			    }
			    notifyObservers();
			    checkDeath();
			    if(shooting == true && !pauseFlag) {
			        if(currentMode == 1) {
			            setLoop(0, 0, 3, 0, 0, 60);
			            currentMode++;
			        } else if(currentMode == 2) {
			            if(nowFrame == 2) {
			                setLoop(0, 2, 2, 2, 0, 10);
			                pauseFlag = true;
			                new FlipTimer(this, "incrementMode", 1000);
			            }
			        } else if(currentMode == 3) {
			            myActorCannon.fire();
			            var soundChannel = chandelierSound.play(0);
			            currentMode++;
			        } else if(currentMode == 4) {
			            pauseFlag = true;
			            new FlipTimer(this, "incrementMode", 1000);
			        } else if(currentMode == 5) {
			            setLoop(0, 2, 3, 0, 0, 60);
			            currentMode++;
			        } else if(currentMode == 6) {
			            if(nowFrame == 0) {
			                setLoop(0, 0, 0, 0, 0);
			                currentMode++;
			                new FlipTimer(this, "shotReset", 2000);
			            }
			        }
			        
			    }
			}
			animate();
		}
	
    }
    
    
}