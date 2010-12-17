package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
	import engine.actors.weapons.BaseballWeapon;
	import engine.actors.player.Hero;
    
    public class EnemyPitcher extends EnemyWalker {
	
		protected const WALKING = 1;
		protected const SHOOTING = 2;
		protected var currentStatus = WALKING;
		
		protected var actionCounter:Number = 0; // holder var for how many frames go by between actions
		protected const walkDuration = 60; // how long we spend walking
		protected var shootDelay = Math.floor((Math.random() * 60) + 75); // how long we wait between bullets
		protected const baseballsMax = 1; // how many bullets we're allowed to fire
		protected var baseballCounter:Number = 0; // how many bullets have we fired 
		
		override public function setup() {
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
    		
    		points = 250;
    		
    		myName = "EnemyPitcher"; // the generic name of our enemy
            mySkin = "PitcherSkin"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance
			walkSpeed = 1;
			goingLeft = 1;
		}
		
		private function throwBall() {
			var multiplier = 0;
			if(!goingLeft) {
				multiplier = 1;
			}
		    myMap.spawnActor(new BaseballWeapon(this), this.x + (multiplier * this.width), this.y + 4);
		}
		
		override public function notify(subject:*):void {
		    if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
		    }
		
			if(subject is Hero) {
				if(subject.x < this.x) {
					goingLeft = 1;
				} else {
					goingLeft = 0;
				}
			}
		}
		
		override public function moveMe():void {
			
			if(goingLeft) {
				velx = -walkSpeed;
			} else {
				velx = walkSpeed;
			}
			
			if(this.x == 228 || this.x == 0 && currentStatus != SHOOTING) {
				walkSpeed = 0;
				currentStatus = SHOOTING;
			}
			
			if(frameCount >= frameDelay) { 
				if(currentStatus == WALKING) { // if we're walking
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
				} else if(currentStatus == SHOOTING) { 		// otherwise, if we're shooting
					if(actionCounter >= shootDelay) {	// and we've waiting enough time between shots
							throwBall(); // then shoot the gun
							baseballCounter++; // increment our bullet counter
							actionCounter = 0; // and reset our action counter
							setLoop(0, 2, 3, 2, 0, 30);	
					}
				}
    			frameStarted = true;
				statusSet = false;

		        this.y += vely / 2; // update our y variable
    			
    			notifyObservers(); // tell everybody where we are now
    			applyPhysics(); // apply our enviromental variables
    			updateStatus(); // update our status
                frameCount = 0;
				frameStarted = false;
				actionCounter++;
		    }
		    animate();
		}
		
		override public function applyPhysics():void {
		    // velocitize y (gravity)
			if (this.vely < MAX_VEL_Y) {
			    this.vely += this.gravity;
            }
		}
		
		
    }
    
}