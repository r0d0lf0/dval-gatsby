package engine.actors.player {
	import flash.display.MovieClip;
	//import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.events.Event;
	import engine.actors.Actor;
	import engine.actors.Animatable;
	import engine.actors.geoms.*;
	import engine.actors.specials.*;
	import controls.KeyMap;
	import engine.actors.weapons.Weapon;
	import engine.ISubject;
	import engine.actors.weapons.HatWeapon;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import engine.Scoreboard;

	dynamic public class Hero extends Animatable{
	    	    
	    // these hold what things we can currently do
	    private var walkEnabled = true;
	    private var jumpEnabled = false;
	    private var shootEnabled = true;
	    private var hatAvailable = true;
	    
		//CHANGE THESE
		public var jumpVelocity:uint = 10; //exponential. 20 jumps 3x higher than 10
		
		public var Xspeed:Number = 2;
		
		private var frameDelay:Number = 0; // number of frames 
		private var frameCount:Number = 0; // current frame count
		
		//
		public var fric:Number = 1;  //frictional coefficient of go
		public var gravity:Number = 1;  //how much the velocity changes on each frameEvent
		
		
		public var hat;
		// public var airFric:Number = 1; // not sure yet 
		// MAX_VEL_Y has to be less than the height of most shallow platform.
		// otherwise you will fall through the ground
		const MAX_VEL_Y:Number = 6; // so min platform height should be 22.
		const MAX_VEL_X:Number = 3;
		//DON'T CHANGE THESE
		public var vely:Number = 0;
		public var velx:Number = 0;
		public var imon:Boolean = false; // On|Off the ground = true|false (stnading sure-footedly)
		public var ihit:Boolean = false; // On|Off any object = true|false (smack a wall, hit by baddy)
		public var ldir:Boolean = true;  // Right|Left = true|false (last direction player went)
		private var keys:KeyMap = new KeyMap();
		private var myAction:uint = 3;
		private var previousAction;
		private var colliders:Array = new Array();  // temporary storage for all our colliders
		
		private var keyboardStatus:Array = new Array();
		
		private var jumpCount:Number = 0;
		private var jumpPressed:Boolean = false;
		private var attackFlag:Boolean = false;
		private var duckFlag:Boolean = false;
		private var standFlag:Boolean = false;
		
		private var jumpSound = new hero_jump();
		private var hurtSound = new hero_hurt();
		private var powerupSound = new powerup_sound();
		private var throwSound = new hero_throw();
		private var effectsChannel;
		
		private var stuckTo; // what surface are we currently stuck to
		
		private var damageFlag = false; // flag for if the hero has been damaged
		private var damageCounter = 0; // counter variable to see how long we've been damaged
		private var damageDuration = 120; // number of frames to be invincible after damage
		
		private var maxHP = 3; // max number of health points
		private var HP = maxHP; // starting HP
		
		private var frameStarted:Boolean = false;
		private var statusSet:Boolean = false;
		private var map;
		
		private var newAction;
		private var prevAction;
		private var scoreboard = Scoreboard.getInstance();
		
		// constructor, geesh
		public function Hero():void {    
		    //observers = new Array(); // initialize our observers array
			//trace("game loaded");
			if (stage != null) {
				buildHero();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			buildHero();
		}
		private function buildHero():void{
			keys.addEventListener(KeyMap.KEY_UP, onKeyRelease);
			hat = new HatWeapon(this);
		}
		
		public override function update():void {
		    if(damageFlag) {  // if we're being damaged
		        if(damageCounter < damageDuration) { // flicker our alpha
		            this.alpha = damageCounter % 2; // every other frame
		            damageCounter++; // and count how long we've been damaged
		        } else { // if there's a damage flag, and duration is up
		            damageCounter = 0; // reset the damage counter
		            damageFlag = false; // and remove damage flag
		        }
		    }
		    moveMe();
		}
		
		// keeps anim going if it needs to
		private function onKeyRelease(evt:Event):void{
		    
		}
		
		override public function setup() {
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
		    
		    myName = "Hero"; // the generic name of our enemy
            mySkin = "HeroSkin"; // the name of the skin for this enemy
		}	
		
		private function flipCollide(collide) {
		    return this.width - collide;
		}
		
		public function receiveDamage(damageAmount):void {
		    if(!damageFlag) {
		        HP -= damageAmount;
		        scoreboard.setHP(HP);
    		    damageFlag = true;
    		    effectsChannel = hurtSound.play(0);  // play it
		    }
		}
		
		public function receivePowerup(powerup):void {
		    if(powerup is HealthPowerup) {
		        HP += powerup.health;
		        if(HP > maxHP) {
		            HP = maxHP;
		        }
    		    scoreboard.setHP(HP);
		    } else if(powerup is ScorePowerup) {
		        scoreboard.addToScore(powerup.points);
		    }

		    effectsChannel = powerupSound.play(0);
		    map.removeFromMap(powerup);
		}
		
		private function land(observer):void {
		    this.vely = 0;
		    if(observer is FountainPlatform) {
		        this.y = (observer.y + observer.velocity) - this.height;
		    } else {
		        this.y = observer.y - this.height;
		    }
	        jumpCount = 0;
	        standFlag = true;
	        if(stuckTo != observer) {
	            stuckTo = observer;
	        }
		}
		
		private function depart(observer):void {
		    standFlag = false;
		    stuckTo = false;
		    trace("departed!");
		}
		
		private function checkRight(observer):Boolean {
		    if((this.x + this.collide_left) < observer.x + observer.width) { // if we're collided with the square's right side currently
		        if((this.x + this.collide_left) - this.velx >= observer.x + observer.width) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
		
		private function checkLeft(observer):Boolean {
		    if((this.x + this.collide_right) > observer.x) { // if we're collided with the block's left side currently
		        if((this.x + this.collide_right) - this.velx <= observer.x) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
		
		private function getGlobals(observer) {
		    var localCoords = new Point(observer.x, observer.y);
            var globalCoords = observer.localToGlobal(localCoords);
            return globalCoords;
		}
		
		private function checkTop(observer):Boolean {
                trace("Platform: x:" + observer.x + "y:" + observer.y);
                var globalCoords = getGlobals(observer);
                trace("Global: x:" + (observer.parent.x + observer.parent.height));
                trace("Hero: x:" + this.x + "y:" + this.y);
    		    if((this.y + this.height) > observer.y) { // if we're collided with the top currently
    		        if((this.y + this.height) - this.vely <= observer.y) { // and we hadn't collided in the previous frame
    		            return true;
    		        }
    		    }
            //}
            return false;
		}
		
		public function collide(observer, ...args) {
		    if(observer is Cloud || observer is FountainPlatform) {
		        if(checkTop(observer) || observer == stuckTo) {
		            land(observer);
		            if(observer is FountainPlatform) {
		                trace("landing on platform!");
		            }
		        }
		    } else if(observer is Door) {
		        trace("Door collision!");
		    } else if(observer is Block) {
                if(checkRight(observer)) {  // if we hit the right edge of the block
	                this.x = (observer.x + observer.width) - collide_left; // set us to there
	            } else if(checkLeft(observer)) { // if we hit the left edge of the block
	                this.x = observer.x - collide_right; // stop us there
	            } else if(myAction == FALL) { // if we just fell and collided
    	             land(observer); // land us on the top
	            } else if(observer == stuckTo) { // otherwise, if we're colliding with the thing we're stuck to
	                land(observer); // continue to follow it
	            }
		    }
		}
		
		public function getHP():Number {
		    return HP;
		}
		
		public function setMap(map) {
		    this.map = map;
		}
	    
	    private function readInput():void {
	        
	        if(walkEnabled) {  // if we're allowed to walk, input our walk info
	            if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {					
					this.velx += this.Xspeed;
					goingLeft = 0;
                    if(this.velx > MAX_VEL_X) {
                        this.velx = MAX_VEL_X;
                    }
				} else if(KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					this.velx -= this.Xspeed;
					goingLeft = 1;
					if(this.velx < -MAX_VEL_X) {
					    this.velx = -MAX_VEL_X;
					}
				}
				if(myAction != FALL) {
				    
				}
	        }
	        
	        if(jumpEnabled == true && jumpCount == 0 && jumpPressed == false) { // if we're allowed to jump
	            if (KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
					// -speed breaks the moving platform buffer s well as still platforms.
					effectsChannel = jumpSound.play(0);  // play it, looping 100 times
					this.y -= gravity;
					this.vely = -jumpVelocity;
					jumpCount++;
					jumpPressed = true;
				}
	        }
	        
	        if(shootEnabled && hatAvailable) {
	            if(KeyMap.keyMap[88] || KeyMap.keyMap[17]) {
	                if(hatAvailable) {
	                   throwHat(); 
	                }
	            }
	        }
	        
	        if(KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
	            jumpPressed = true;
	        } else {
	            jumpPressed = false;
	        }
	        
	    }
	    
	    private function throwHat() {
	        throwSound.play(0);
	        hat.throwHat(goingLeft);
	        map.spawnActor(hat);
            trace("Shoot!");
            hatAvailable = false;
	    }
	    
	    public function catchMe(object) {
	        if(!hatAvailable) {
	            map.removeFromMap(object);
    	        hatAvailable = true;
	        }
	    }
	    
	    private function updateStatus():void {
	        newAction = STAND; // by default, we're standing
	        
	        if(standFlag) { // if we're standing on something
	            if(!stuckTo.checkCollision(this)) { // and we're colliding with it anymore
	                depart(stuckTo); // depart whatever platform we were on
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
//                trace("New Action = " + newAction);
                setAction(newAction);
                setAnimation(newAction);
            }
            prevAction = newAction;
	    }
	    
	    public function setAction(myAction) {
	        if(this.myAction != myAction) { // if we're defining a new action
	            this.myAction = myAction;
	            if(myAction == JUMP || myAction == FALL) {
	                walkEnabled = true;
	                jumpEnabled = false;
	                shootEnabled = true;
	            } else if(myAction == STAND || myAction == WALK) {
	                walkEnabled = true;
	                jumpEnabled = true;
	                shootEnabled = true;
	            }
	        }
		}
		
		public function setAnimation(status) {
			switch(myAction) {
		        case WALK:
		            setLoop(0, 1, 4, 2, 1);
		            break;
		        case JUMP:
		            setLoop(2, 2, 2, 2, 0);
		            break;
		        case STAND:
		            setLoop(0, 0, 0, 0, 0);
		            break;
		        case FALL:
		            setLoop(2, 2, 2, 2, 0);
		            break;
		        case DUCK:
		            setLoop(4, 0, 1, 1, 1);
		            break;
		        case THROW:
		            setLoop(6, 0, 1, 1, 1);
		            break;
		        case DIE:
		            setLoop(8, 0, 1, 0, 0);
		            break;
		    }
		}
	    
	    private function applyPhysics():void {

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
				
		        readInput(); // read our keyboard input and apply what is valid

		        this.y += vely; // update our y variable
    			this.x += velx; // update our x variable
    			
    			notifyObservers(); // tell everybody where we are now
    			
    			applyPhysics(); // apply our enviromental variables
    			
    			updateStatus(); // update our status

				animate(); // animate, now that we know what we're doing

    			frameCount = 0;
				frameStarted = false;
		    } else {
		        frameCount++;
		    }
		    
		}
		
		
	}
}