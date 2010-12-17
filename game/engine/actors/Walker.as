package engine.actors {

   import engine.actors.Animatable;
   import engine.actors.geoms.*;
   import flash.geom.Point;
   import engine.Scoreboard;
   
   public class Walker extends Animatable {
       
       	// MAX_VEL_Y has to be less than the height of most shallow platform.
		// otherwise you will fall through the ground
		protected const MAX_VEL_Y:Number = 8; // so min platform height should be 22.
		protected const MAX_VEL_X:Number = 3;
		protected var walkSpeed:Number = 1;
		
		//DON'T CHANGE THESE
		public var vely:Number = 0;
		public var velx:Number = walkSpeed;

        protected var scoreboard = Scoreboard.getInstance();
		
		//CHANGE THESE
		public var jumpVelocity:uint = 13; //exponential. 20 jumps 3x higher than 10
		public var Xspeed:Number = 4;
		
		//
		public var fric:Number = 1;  //frictional coefficient of go
		public var gravity:Number = 1;  //how much the velocity changes on each frameEvent
		
		protected var jumpCount:Number = 0;
		protected var jumpPressed:Boolean = false;
		protected var attackFlag:Boolean = false;
		protected var duckFlag:Boolean = false;
		protected var standFlag:Boolean = false;
		protected var stuckTo = false; // what surface are we currently stuck to
		protected var hitDirection:String; // what direction were we hit from
		
		protected var frameStarted:Boolean = false;
		protected var statusSet:Boolean = false;
				
		protected var walkEnabled = true;
	    protected var jumpEnabled = false;
		protected var deadFlag:Boolean = false;
		
		protected var newAction;
		protected var prevAction;
		
		protected var myAction:uint = 3;
		

       
       public function Walker() {
           trace("mover created");
       }
       
       	public function land(observer):void {
		    this.vely = 0;
			var observerHeight:Number;
			
			if(observer is FountainPlatform) {
				observerHeight = observer.convertedY;
			} else {
				observerHeight = observer.y;
			}
			
		    if(observer is FountainPlatform) {
		        this.y = (observerHeight + observer.velocity) - this.height;
		    } else {
		        this.y = observerHeight - this.height;
		    }
	        jumpCount = 0;
	        standFlag = true;
	        if(stuckTo != observer) {
	            stuckTo = observer;
	        }
		}
		
		public function depart(observer):void {
		    standFlag = false;
		    stuckTo = false;
		}
		
		public function checkRight(observer):Boolean {
		    if((this.x + this.collide_left_ground) < observer.x + observer.width) { // if we're collided with the square's right side currently
		        if((this.x + this.collide_left_ground) - this.velx >= observer.x + observer.width) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
		
		public function checkLeft(observer):Boolean {
		    if((this.x + this.collide_right_ground) > observer.x) { // if we're collided with the block's left side currently
		        if((this.x + this.collide_right_ground) - this.velx <= observer.x) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
		
		public function checkTop(observer):Boolean {
			var observerHeight:Number;
			var observerX:Number;
			if(observer is FountainPlatform) {
				observerHeight = observer.convertedY;
				observerX = observer.convertedX;
			} else {
				observerHeight = observer.y;
				observerX = observer.x;
			}
			
			if((this.x + this.collide_right_ground) > observerX && (this.x + this.collide_left_ground) < (observerX + observer.width)) {
			    if((this.y + this.height) >= observerHeight) { // if we're collided with the top currently
			        if((this.y + this.height) - this.vely <= observerHeight) { // and we hadn't collided in the previous frame
			            return true;  // then we've just collided with the top
			        }
			    }	
			}
            return false;
		}
		
		public function checkWidth(observer):Boolean {
			var observerX:Number;
			if(observer is FountainPlatform) {
				observerX = observer.convertedX;
			} else {
				observerX = observer.x;
			}
			
			if((this.x + this.collide_right_ground) > observerX && (this.x + this.collide_left_ground) < (observerX + observer.width)) {
				return true;	
			}
            return false;
		}
		
		public function flipCollide(collide) {
		    return this.width - collide;
		}
		
		override public function collide(observer, ...args) {
		    if(observer is Cloud || observer is FountainPlatform) {  // if we're a cloud or a fountain
		        if(checkTop(observer) || observer == stuckTo) { // if we just collided with the top of it, or we're already stuckTo it
		            land(observer); // land on it again
		        }
		    } else if(observer is Block) { // otherwise, if it's a block
                if(checkRight(observer)) {  // if we hit the right edge of the block
	                this.x = (observer.x + observer.width) - collide_left_ground; // set us to there
	            } else if(checkLeft(observer)) { // if we hit the left edge of the block
	                this.x = observer.x - collide_right_ground; // stop us there
	            } else if(myAction == FALL && checkTop(observer)) { // if we just fell and collided with the top
    	             land(observer); // land us on the top
	            } else if(observer == stuckTo) { // otherwise, if we're colliding with the thing we're stuck to
	                land(observer); // continue to follow it
	            }
		    } else if(observer is KillBlock) {
				receiveDamage(observer);
			}
		}
		
		public function updateStatus():void {
	        newAction = STAND; // by default, we're standing
	        
	        if(standFlag) { // if we're standing on something
				if(!stuckTo.checkGroundCollision(this)) { // and we're not colliding with it anymore
					if(stuckTo is FountainPlatform && checkWidth(stuckTo) && jumpCount == 0) {
						land(stuckTo);
					} else {
						depart(stuckTo); // depart whatever platform we were on
					}
	            } else if(velx == 0) { // otherwise, if we're not moving
	                newAction = STAND; // we're standing
	            } else { // otherwise, we're walking
	                newAction = WALK;
	            }
	        } else if(vely < 0) { // if we're going up
	            newAction = JUMP; // we're jumping
	        } else if(vely > 0) { // if we're going down
	            newAction = FALL; // we're falling
	        } else { // otherwise, we just peaked in a jump
	            newAction = FALL; // now we're falling
	        }
	        
            if(newAction != prevAction) {
                setAction(newAction);
                setAnimation(newAction);
            }
            prevAction = newAction;
	    }
	    
	    public function applyPhysics():void {
		    // velocitize y (gravity)
			if (this.vely < MAX_VEL_Y) {
			    this.vely += this.gravity;
            }
			
			// apply friction
			if (this.velx > 0) {
				this.velx -= fric;
			} else if (this.velx < 0) {
				this.velx += fric;
			}
			
			// check map bounds
			if(this.x < 0) {
			    this.x = 0;
			}
		}
		
		public function moveMe():void {
		    if(frameCount >= frameDelay) { 
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
    			applyPhysics(); // apply our enviromental variables
    			updateStatus(); // update our status
                frameCount = 0;
				frameStarted = false;
		    } else {
		        frameCount++;
		    }
		    animate();
		}
	    
	    public function setAction(myAction) {
	        if(this.myAction != myAction) { // if we're defining a new action
	            this.myAction = myAction;
	            if(myAction == JUMP || myAction == FALL) {
	                walkEnabled = true;
	                jumpEnabled = false;
	            } else if(myAction == STAND || myAction == WALK) {
	                walkEnabled = true;
	                jumpEnabled = true;
	            }
	        }
		}
		
		public function setAnimation(status) {
			switch(myAction) {
		        default:
		            setLoop(loopRow, startFrame, endFrame, loopFrame, loopType);
		            break;
		    }
		}
		
		public function killMe():void {
		    if(myStatus != 'DYING') {
				HP = 0;
	            myStatus = 'DYING';
	            if(hitDirection == 'LEFT') {
	                this.velx = 3;
	            } else if(hitDirection == 'RIGHT')  {
	                this.velx = -3;
	            }
				notifyObservers();
	            this.vely = -10;
	        }
		    if(frameCount >= frameDelay) {
		        applyPhysics();
		        this.y += vely;
		        animate();
		        if(this.y > 240) {
		            myMap.removeFromMap(this);
		        }
		    } else {
		        frameCount++;
		    }
		}
       
   }
    
}
