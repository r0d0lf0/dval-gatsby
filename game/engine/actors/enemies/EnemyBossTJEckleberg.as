package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
	import engine.actors.player.Hero;
	import engine.Scoreboard;
	import engine.actors.Explosion;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import flash.geom.Point;
	import engine.actors.weapons.LaserWeapon;
    
    public class EnemyBossTJEckleberg extends EnemyWalker {
	
		private var laserSound = new laser_sound();
		private var roarSound = new tjeckleberg_roar();
		private var explodeSound = new bullet_sound();
		
		protected const flyingDuration = 60;
		protected const damageDuration = 60;
		protected const shootWarningDuration = 15;
		protected const shootDuration = 0;
	
		protected var actionDelay = flyingDuration;
		protected var actionCounter = 0;
		protected var currentRow = 0;
		protected const FLYING = 1;
		protected const SHOOTING = 2;
		protected const SHOOT_WARNING = 3;
		
		protected var damagedFlag = 0;
		protected var damagedCounter = 0;
		protected const damagedDuration = 60;
		
		protected var destinationPoint:Point = new Point(296, 60);
		protected var destArray = new Array();
		protected var currentPoint:Point = new Point(0, 0);
		protected var pointCounter = 0;
		protected const pointProximity = 25;
		
		protected var prevVelx = 0;
		protected var prevVely = 0;
		
		protected var myHero = null;
		
		protected var maxVel = 4; // fastest we're allowed to go by the universe
		protected var INERTIA = .25; // the fastest we're allowed to increase in velocity per frame
		
		protected var currentAction = FLYING;
		protected var deathRow = 4;		
		
		protected var explosionCounter = 0;
		protected var explosionMax = 8;
		
		override public function setup() {
		    collide_left = 0; // what pixel do we collide on on the left
    		collide_right = 112; // what pixel do we collide on on the right

			walkSpeed = 0;
			velx = walkSpeed;
			HP = 5;
			
			deathFrame = 0;
			
			points = 2500;
    		
    		myName = "TJ ECKLEBERG"; // the generic name of our enemy
            mySkin = "TJEcklebergSkinBig"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance            
		
			destArray = new Array( (new Point(80, 55)), (new Point(196, 55)) );
			// place our explosions
		
		    tilesWide = 7;
		    tilesTall = 3;
		}
		
		private function getCurrentFrame() {
		    return getRectangle(currentRow, nowFrame);
		}
		
		override public function killMe():void {
			HP = 0;
		    if(myStatus != 'DYING') {
				setLoop(deathRow, 0, 1, 0, 0, 2); // make us die
	            myStatus = 'DYING';
	            this.vely = -4;
	            if(hitDirection == 'LEFT') {
	                this.velx = 3;
	            } else if(hitDirection == 'RIGHT')  {
	                this.velx = -3;
	            }
	        }
		    if(frameCount >= frameDelay) {
		        applyPhysics();
		        this.y += vely;
		        if(vely >= 1) {
		            vely = 1;
		        }
		        animate();
		        explosionCounter++;
		        if(explosionCounter >= explosionMax) {
		            var myExplosion = new Explosion();
		            myMap.spawnActor(myExplosion, (Math.floor(Math.random() * this.width) + this.x - 16), (Math.floor(Math.random() * this.height) + this.y - 16));
		            explosionCounter = 0;
		            explosionMax = Math.floor(Math.random() * 3) + 8;
		        }
		        
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
					setLoop(currentRow, 0, damagedFlag, 0, 0, 2);
				}
			} else if(heroDelta > 0 && heroDelta < 64) {
				if(currentRow != 1) {
					currentRow = 1;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 2);
				}
			} else if(heroDelta > -64 && heroDelta < 0) {
				if(currentRow != 2) {
					currentRow = 2;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 2);
				}
			} else if(heroDelta < -64) {
				if(currentRow != 3) {
					currentRow = 3;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 2);
				}
			}
			
			
		}
		
		override public function notify(subject:*):void {
            if(subject is Hero) {
                if(!deadFlag && INERTIA != 0) {
                    moveEyes(subject);
                }
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
	                if(attacker.velx > 0) {
	                    this.velx = 1;
	                } else {
	                    this.velx = -1;
	                }
	            }
	            scoreboard.setBossHP(HP);
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
			
			var laserLeft = new LaserWeapon(this, heroVX, heroVY);
			var laserRight = new LaserWeapon(this, heroVX, heroVY);
			myMap.spawnActor(laserLeft, thisCenter.x - 25, thisCenter.y);
			myMap.spawnActor(laserRight, thisCenter.x + 25, thisCenter.y);
			var soundChannel = laserSound.play(0);
			
		}
		
		private function updatePoints() {
			// see how close we are to our destination point
			var currentPoint = new Point(this.x + (this.width / 2), this.y + (this.height / 2));
			var destPoint = destArray[pointCounter];
			if(Math.abs(destPoint.x - currentPoint.x) <= pointProximity && Math.abs(destPoint.y - currentPoint.y) <= pointProximity) {
				pointCounter++;
			}

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
			
			if(Math.abs(velx) > maxVel) {
				if(velx < 0) {
					velx = -maxVel;
				} else {
					velx = maxVel;
				}
			}
			
			if(Math.abs(vely) > maxVel) {
				if(vely < 0) {
					vely = -maxVel;
				} else {
					vely = maxVel;
				}
			}
			
		}
		
		override public function updateStatus():void {
			
	    }
		
		override public function moveMe():void {
			updatePoints();
			flyToPoint(destArray[pointCounter]);
			frameCount++;
			if(frameCount >= frameDelay) { 
				if(actionCounter >= actionDelay) { // if we've waited long enough for our current action
					if(currentAction == FLYING) { // and we're flying
						actionDelay = shootWarningDuration; // set our delay value
						currentAction = SHOOT_WARNING; // switch us to shoot warning mode
						setLoop(currentRow, 0, 1, 0, 0, 3); // set our animation to do what it does
					} else if(currentAction == SHOOT_WARNING) { // otherwise, if we're shoot warning, then we're done
						setLoop(currentRow, 0, 0, 0, 0, 10); // set us back to normal animation
						actionDelay = shootDuration; // set our pause duration to shoot
						currentAction = SHOOTING; // and set us to ready to shoot
					} else if(currentAction == SHOOTING) { // otherwise, if we're ready to shoot
					    this.velx = walkSpeed;
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

		        this.y += vely / 2; // update our y variable
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
    			//applyPhysics(); // apply our enviromental variables
				updateStatus(); // update our status

				frameCount = 0;
				frameStarted = false;
				actionCounter++;
				
				if(HP <= 1) {
				    setLoop(currentRow, 1, 1, 1, 0, 5);
				    maxVel = 7;
				    INERTIA = .3;
				}
		    }
		    animate();
		}
        
    }
    
}