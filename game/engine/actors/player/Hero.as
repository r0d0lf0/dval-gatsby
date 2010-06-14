﻿package engine.actors.player {
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
	import engine.ISubscriber;
	import engine.Subscriber;
	import engine.ISubject;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import engine.Scoreboard;

	dynamic public class Hero extends Animatable implements ISubject {
	    
	    // Here's where the observer pattern stuff goes
	    private var observers:Array = new Array();
	    
	    // these hold what things we can currently do
	    private var walkEnabled = true;
	    private var jumpEnabled = true;
	    private var shootEnabled = true;
	    
		//CHANGE THESE
		public var jumpVelocity:uint = 10; //exponential. 20 jumps 3x higher than 10
		
		public var Xspeed:Number = 2;
		
		private var frameDelay:Number = 0; // number of frames 
		private var frameCount:Number = 0; // current frame count
		
		//
		public var fric:Number = 1;  //frictional coefficient of go
		public var gravity:Number = 1;  //how much the velocity changes on each frameEvent
		
		
		public var hat:Weapon = new Weapon(1);
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
		private var myAction:uint = 0;
		private var previousAction;
		private var colliders:Array = new Array();  // temporary storage for all our colliders
		
		private var keyboardStatus:Array = new Array();
		
		private var jumpCount:Number = 0;
		private var jumpPressed:Boolean = false;
		
		private var jumpSound = new hero_jump();
		private var hurtSound = new hero_hurt();
		private var effectsChannel;
		
		private var damageFlag = false; // flag for if the hero has been damaged
		private var damageCounter = 0; // counter variable to see how long we've been damaged
		private var damageDuration = 120; // number of frames to be invincible after damage
		private var HP = 3; // number of health points
		
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
			skinHero();
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
		
		//show some skin
		private function skinHero() {
			setSkin('HeroSkin',2,2);
		}
		
		public function receiveDamage(damageAmount):void {
		    if(!damageFlag) {
		        HP -= damageAmount;
		        scoreboard.addToScore(10);
		        scoreboard.setHP(HP);
    		    damageFlag = true;
    		    effectsChannel = hurtSound.play(0);  // play it, looping 100 times
		    }
		}
		
		public function addObserver(observer):void {
		    observers.push(observer);
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1); break;
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
		public function collide(observer, ...args) {
		    if(observer is Cloud) {
		        if(myAction == FALL) {
		            this.vely = 0;
    		        this.y = observer.y;
		        }
		    } else if(observer is Door) {
		        trace("Door collision!");
		    }
		}
		
		public function getHP():Number {
		    return HP;
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
	        }
	        
	        if(jumpEnabled == true && jumpCount == 0) { // if we're allowed to jump
	            if (KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
					// -speed breaks the moving platform buffer s well as still platforms.
					effectsChannel = jumpSound.play(0);  // play it, looping 100 times
					this.y -= gravity;
					this.vely = -jumpVelocity;
					jumpCount++;
				}
	        }
	        
	        
	        if (!KeyMap.keyMap[32] && !KeyMap.keyMap[38]) {
                jumpCount = 0;
	        }
	        
	    }
	    
	    private function updateStatus():void {
	        // set our status
			if(vely < 0) {
			    setAction(JUMP);
			} else if(vely > 0) {
			    setAction(FALL);
			} else if(velx == 0) {
		        setAction(STAND);
		    } else {
		        setAction(WALK);
		    }
	    }
	    
	    public function setAction(myAction) {
	        if(this.myAction != myAction) {
	            trace("Action changed from " + this.myAction + " to " + myAction);
	            this.myAction = myAction;
    		    switch(myAction) {
    		        case WALK:
    		            setLoop(0, 0, 3, 1, 1);
    		            break;
    		        case JUMP:
    		            setLoop(2, 0, 1, 1, 1);
    		            break;
    		        case STAND:
    		            setLoop(0, 5, 5, 5, 1);
    		            break;
    		        case FALL:
    		            setLoop(2, 1, 1, 1, 1);
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
		        
		        readInput(); // read our keyboard input and apply what is valid
		        this.y += vely; // update our y variable
    			this.x += velx; // update our x variable
    			
    			updateStatus(); // update our status variable since physics update
    		    applyPhysics(); // apply our enviromental variables
    		    notifyObservers(); // tell everybody where we are now

                animate(); // animate, now that we know what we're doing
                
    			
    			frameCount = 0;
		    } else {
		        frameCount++;
		    }
		    
		}
		
		
	}
}