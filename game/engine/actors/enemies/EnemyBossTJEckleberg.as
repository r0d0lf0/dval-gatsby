package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
	import engine.actors.player.Hero;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import flash.geom.Point;
	import engine.actors.weapons.LaserWeapon;
    
    public class EnemyBossTJEckleberg extends EnemyWalker {
	
		private var laserSound = new laser_sound();
		private var roarSound = new tjeckleberg_roar();
	
		protected const flyingDuration = 30;
		protected const damageDuration = 30;
		protected const shootWarningDuration = 10;
		protected const shootDuration = 0;
	
		protected var actionDelay = flyingDuration;
		protected var actionCounter = 0;
		protected var currentRow = 0;
		protected const FLYING = 1;
		protected const SHOOTING = 2;
		protected const SHOOT_WARNING = 3;
		
		protected var damagedFlag = 0;
		protected var damagedCounter = 0;
		protected const damagedDuration = 30;
		
		protected var destinationPoint:Point = new Point(256, 40);
		protected var destArray = new Array();
		protected var currentPoint:Point = new Point(0, 0);
		protected var pointCounter = 0;
		protected const pointProximity = 20;
		
		protected var myHero = null;
		
		protected const MAX_VEL = 3; // fastest we're allowed to go by the universe
		protected const INERTIA = .25; // the fastest we're allowed to increase in velocity per frame
		
		protected var currentAction = FLYING;
		
		override public function setup() {
		    collide_left = 0; // what pixel do we collide on on the left
    		collide_right = 64; // what pixel do we collide on on the right

			walkSpeed = 0;
			velx = walkSpeed;
			HP = 5;
    		
    		myName = "EnemyBossTJEckleberg"; // the generic name of our enemy
            mySkin = "TJEcklebergSkin2"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance            
		
			destArray = new Array( (new Point(this.x, 33)), (new Point(this.x + 128, 33)) );
		
		    tilesWide = 5;
		    tilesTall = 2;
		}
		
		private function getCurrentFrame() {
		    return getRectangle(currentRow, nowFrame);
		}
		
		override public function killMe():void {
			HP = 0;
		    if(myStatus != 'DYING') {
				setLoop(1, 1, 1, 1, 0, 1); // make us die
	            myStatus = 'DYING';
	            this.vely = -10;
	            if(hitDirection == 'LEFT') {
	                this.velx = 3;
	            } else if(hitDirection == 'RIGHT')  {
	                this.velx = -3;
	            }
	        }
		    if(frameCount >= frameDelay) {
		        applyPhysics();
		        this.y += vely;
		        animate();
		        if(this.y > 240) {
					myStatus = 'DEAD';
					myMap.updateStatus(COMPLETE);
		            myMap.removeFromMap(this);
		        }
		    } else {
		        frameCount++;
		    }
		}
		
		private function moveEyes(hero) {
			if(currentAction == SHOOT_WARNING) {
			//	var damagedFlag = 1;
			}
			var heroDelta = (this.x + (this.width / 2)) - (hero.x + (this.height / 2)); // subtract Eckleberg's center from the hero's and see what's what
			if(heroDelta > 64) {
				if(currentRow != 0) {
					currentRow = 0;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 1);
				}
			} else if(heroDelta > 0 && heroDelta < 64) {
				if(currentRow != 1) {
					currentRow = 1;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 1);
				}
			} else if(heroDelta > -64 && heroDelta < 0) {
				if(currentRow != 2) {
					currentRow = 2;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 1);
				}
			} else if(heroDelta < -64) {
				if(currentRow != 3) {
					currentRow = 3;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 1);
				}
			}
			
			
		}
		
		override public function notify(subject:*):void {
		    if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
		    }
		
			if(subject is Hero) {
				moveEyes(subject);
				if(myHero == null) {
					myHero = subject;
				}
			}
		}
		
		// the hero will use this to deal damage
        override public function receiveDamage(attacker):void {
			if(damagedFlag == 0) {
				var soundChannel = roarSound.play(0);
			    HP -= attacker.damage;
	            if(HP <= 0) {
	                HP = 0;
	                if(attacker.velX > 0) {
	                    this.velx = 1;
	                } else {
	                    this.velx = -1;
	                }
	            }
				damagedFlag = 1;	
			}
        }

		private function shootLaser(hero) {
			
			// calculate the center of each of us
			var thisCenter = new Point(this.x + (this.width / 2), this.y + (this.height / 2));
			var heroCenter = new Point(hero.x + (hero.width / 2), hero.y + (hero.height / 2));
			
			
			// get a vector to the hero's position
			var lenX = (heroCenter.x - thisCenter.x);
			var lenY = (heroCenter.y - thisCenter.y);
			
			// calculate the length of the vector
			var vectorLength = Math.sqrt((lenX * lenX) + (lenY * lenY));
			
			// normalize it
			var heroVX = (lenX / vectorLength);
			var heroVY = (lenY / vectorLength);
			
			trace("Vectors: X=" + heroVX + " Y=" + heroVY);
			
			var newLaser = new LaserWeapon(this, heroVX, heroVY);
			myMap.spawnActor(newLaser, thisCenter.x, thisCenter.y);
			var soundChannel = laserSound.play(0);
			
		}
		
		private function updatePoints() {
			// see how close we are to our destination point
			var currentPoint = new Point(this.x + (this.width / 2), this.y + (this.height / 2));
			var destPoint = destArray[pointCounter];
			if(Math.abs(destPoint.x - currentPoint.x) <= pointProximity && Math.abs(destPoint.y - currentPoint.y) <= pointProximity) {
				pointCounter++;
			}
			trace(Math.abs(destPoint.x - currentPoint.x) + " and " + Math.abs(destPoint.y - currentPoint.y));
			if(pointCounter > (destArray.length - 1)) {
				pointCounter = 0;
			}
		}

		private function flyToPoint(destinationPoint) {
			
			currentPoint = new Point(this.x + (this.width / 2), this.y + (this.height / 2));
			
			if(currentPoint.x < destinationPoint.x) {
				velx += INERTIA;
			} else {
				velx -= INERTIA;
			}
			
			if(currentPoint.y < destinationPoint.y) {
				vely += INERTIA;
			} else {
				vely -= INERTIA;
			}
			
			if(Math.abs(velx) > MAX_VEL) {
				if(velx < 0) {
					velx = -MAX_VEL;
				} else {
					velx = MAX_VEL;
				}
			}
			
			if(Math.abs(vely) > MAX_VEL) {
				if(vely < 0) {
					vely = -MAX_VEL;
				} else {
					vely = MAX_VEL;
				}
			}
			
		}
		
		override public function updateStatus():void {
			
	    }
		
		override public function moveMe():void {
			updatePoints();
			flyToPoint(destArray[pointCounter]);
			if(frameCount >= frameDelay) { 
				if(actionCounter >= actionDelay) { // if we've waited long enough for our current action
					if(currentAction == FLYING) { // and we're flying
						actionDelay = shootWarningDuration; // set our delay value
						currentAction = SHOOT_WARNING; // switch us to shoot warning mode
						setLoop(currentRow, 0, 1, 0, 0, 1); // set our animation to do what it does
					} else if(currentAction == SHOOT_WARNING) { // otherwise, if we're shoot warning, then we're done
						setLoop(currentRow, 0, 0, 0, 0, 0); // set us back to normal animation
						actionDelay = shootDuration; // set our pause duration to shoot
						currentAction = SHOOTING; // and set us to ready to shoot
					} else if(currentAction == SHOOTING) { // otherwise, if we're ready to shoot
						if(myHero != null) { // if we've got a hero
							shootLaser(myHero); // shoot a laser beam at him
						}
						actionDelay = flyingDuration; // get us prepped to fly
						currentAction = FLYING; // and start just flying
					}
					actionCounter = 0;
				}
				
				if(damagedFlag != 0) {
					if(damagedCounter == 0) {
						setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
					}
					if(damagedCounter >= damagedDuration) {
						damagedFlag = 0;
						damagedCounter = 0;
						setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
					} else {
						damagedCounter++;
					}
				}
				
    			frameStarted = true;
				statusSet = false;

		        this.y += vely; // update our y variable
    			this.x += velx; // update our x variable

    			notifyObservers(); // tell everybody where we are now
    			//applyPhysics(); // apply our enviromental variables
				updateStatus(); // update our status

				frameCount = 0;
				frameStarted = false;
				actionCounter++;
		    }
		    animate();
		
		}
        
    }
    
}