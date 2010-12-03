package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
	import engine.actors.player.Hero;
	
	import flash.geom.Point;
    
    public class EnemyBossTJEckleberg extends EnemyWalker {
	
		protected const actionDelay = 60;
		protected var actionCounter = 0;
		protected var currentRow = 0;
		protected const FLYING = 1;
		protected const SHOOTING = 2;
		
		protected var damagedFlag = 0;
		protected var damagedCounter = 0;
		protected const damagedDuration = 30;
		
		protected var destinationPoint:Point = new Point(256, 50);
		protected var currentPoint:Point = new Point(0, 0);
		
		protected const MAX_VEL = 3; // fastest we're allowed to go by the universe
		protected const INERTIA = .25; // the fastest we're allowed to increase in velocity per frame
		
		protected var currentAction = FLYING;
		
		override public function setup() {
		    collide_left = 0; // what pixel do we collide on on the left
    		collide_right = 64; // what pixel do we collide on on the right

			walkSpeed = 0;
			velx = walkSpeed;
			HP = 10;
    		
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
		
		    tilesWide = 5;
		    tilesTall = 2;
		}
		
		private function getCurrentFrame() {
		    return getRectangle(currentRow, nowFrame);
		}
		
		override public function killMe():void {
			HP = 0;
		    if(myStatus != 'DYING') {
				setLoop(2, 0, 1, 0, 0, 1); // make us die
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
			var heroDelta = (this.x + 32) - (hero.x + 10); // subtract Eckleberg's center from the hero's and see what's what
			if(heroDelta > 64) {
				if(currentRow != 0) {
					currentRow = 0;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
				}
			} else if(heroDelta > 0 && heroDelta < 64) {
				if(currentRow != 1) {
					currentRow = 1;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
				}
			} else if(heroDelta > -64 && heroDelta < 0) {
				if(currentRow != 2) {
					currentRow = 2;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
				}
			} else if(heroDelta < -64) {
				if(currentRow != 3) {
					currentRow = 3;
					setLoop(currentRow, 0, damagedFlag, 0, 0, 0);
				}
			}
			
			
		}
		
		override public function notify(subject:*):void {
		    if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
		    }
		
			if(subject is Hero) {
				moveEyes(subject);
			}
		}
		
		// the hero will use this to deal damage
        override public function receiveDamage(attacker):void {
			if(damagedFlag == 0) {
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
		
		override public function moveMe():void {
			flyToPoint(destinationPoint);
			if(frameCount >= frameDelay) { 
				if(actionCounter >= actionDelay) { // if we've waited long enough
					if(currentAction == FLYING) { // and we're jumping
						//setLoop(0, 0, 3, 0, 1); // make us point
						currentAction = SHOOTING; // switch us to pointing mode
					} else if(currentAction == SHOOTING) { // otherwise, if we're pointing
						//setLoop(1, 0, 3, 0, 1); // make us jump
						currentAction = FLYING; // and switch us to jumping mode
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