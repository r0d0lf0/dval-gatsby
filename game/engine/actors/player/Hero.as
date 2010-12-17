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
	import controls.KeyMap;
	import engine.actors.weapons.Weapon;
	import engine.ISubject;

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
		//public var airFric:Number = 1; // not sure yet 
		// MAX_VEL_Y has to be less than the height of most shallow platform.
		// otherwise you will fall through the ground
		const MAX_VEL_Y:Number = 8; // so min platform height should be 22.
		const MAX_VEL_X:Number = 4;
		//DON'T CHANGE THESE
		public var vely:Number = 0;
		public var velx:Number = 0;
		public var imon:Boolean = false; // On|Off the ground = true|false (stnading sure-footedly)
		public var ihit:Boolean = false; // On|Off any object = true|false (smack a wall, hit by baddy)
		public var ldir:Boolean = true;  // Right|Left = true|false (last direction player went)
		private var keys:KeyMap = new KeyMap();
		private var myStatus:String = 'STANDING';
		private var previousStatus:String = 'STANDING';
		private var colliders:Array = new Array();  // temporary storage for all our colliders
		
		private var keyboardStatus:Array = new Array();
		
		// constructor, geesh
		public function Hero():void {
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
			//trace("hero loaded");
			keys.addEventListener(KeyMap.KEY_UP, onKeyRelease);
			//addChild(hat);
			skinHero();
		}
		
		
		// keeps anim going if it needs to
		private function onKeyRelease(evt:Event):void{
			//aFlag = true;
		}
		//show some skin
		private function skinHero() {
			setSkin('HeroSkin',2,2);
		}
		
		//move avatar		
		
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
		        if(myStatus == 'FALLING') {
		            this.vely = 0;
    		        this.y = observer.y;
    		        myStatus = 'STANDING';
		        }
		    }
		}
		
	    private function handleCollisions():void {
	        for(var i=0; i<colliders.length; i++) {
	            if(colliders[i] is Cloud) {
	                this.y = colliders[i].y;
	            }
	        }
	        colliders = new Array(); // clear this list for our next time round
	    }
	    
	    private function readInput():void {
	        
	        if(walkEnabled) {  // if we're allowed to walk, input our walk info
	            if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					if(this.velx < MAX_VEL_X){
						this.velx += this.Xspeed;
					}
				} else if(KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					if(this.velx > (MAX_VEL_X*-1)){
						this.velx -= this.Xspeed;
					}
				}
	        }
	        
	        if(jumpEnabled == true) { // if we're allowed to jump
	            if (KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
					// -speed breaks the moving platform buffer s well as still platforms.
					this.y -= gravity;
					this.vely = -jumpVelocity;
				}
	        }
	        
	    }
	    
	    private function updateStatus():void {
	        if(myStatus != previousStatus) { // if our status has changed
	            trace(myStatus);
			    switch(myStatus) { // enable/disable abilities

    			    case 'STANDING':
                        walkEnabled = true;
                        jumpEnabled = true;
                        shootEnabled = true;
						aMax = 0; //induces standing
    			        break;
    			    case 'FALLING':
    			        walkEnabled = true;
    			        jumpEnabled = false;
    			        shootEnabled = false;
						aMax = 6; //induces walks
    			        break;
    			    default:
    			        walkEnabled = true;
    			        jumpEnabled = true;
    			        shootEnabled = true;
    			        break;

    			}
			}
			previousStatus = myStatus; // record our previous status
	    }
	    
	    private function applyPhysics():void {
		    
		    // set our status
			if(vely != 0) {
			    myStatus = 'FALLING';
			}

		    // velocitize y (gravity)
			if (this.vely < MAX_VEL_Y) {
				this.vely += this.Yspeed;
			}
			
			// de-velocitize x (friction)
			if(Math.abs(this.velx) < 1) {
			    this.velx = 0;
			}
			if (this.velx > 0) {
				this.velx -= 1;
			} else if (this.velx < 0) {
				this.velx += 1;
			}
			
		}
		
		public function update():void {
			applyPhysics(); // apply our enviromental variables
			updateStatus(); // update our status variable since physics update
			readInput(); // read our keyboard input and apply what is valid
			animate(); // updates nicks frames
			this.y += vely; // update our y variable
			this.x += velx; // update our x variable
			notifyObservers(); // tell everybody where we are now
		}
		
		
	}
}