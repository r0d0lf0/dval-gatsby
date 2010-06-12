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
	import engine.ISubscriber;
	import engine.Subscriber;
	import engine.ISubject;

	dynamic public class Hero extends Animatable implements ISubject {
	    
	    // Here's where the observer pattern stuff goes
	    private var observers:Array = new Array();
	    
	    // these hold what things we can currently do
	    private var walkEnabled = true;
	    private var jumpEnabled = true;
	    private var shootEnabled = true;
	    
		//CHANGE THESE
		public var jumpHeight:uint = 16; //exponential. 20 jumps 3x higher than 10
		public var Yspeed:Number = 2;  //how much the velocity changes on each frameEvent
		public var Xspeed:Number = 1.4;
		
		//
		public var fric:Number = 1;  //frictional coefficient of go
		
		
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
		private var action:uint = 0;
		private var frame:uint = 1;
		private var myStatus:String = 'STANDING';
		private var previousStatus:String = 'STANDING';
		// 1.
		//HeroSkin is subclass of bitmapData. this loads the SpriteSheet into memory
		private var animData:HeroSkin = new HeroSkin(0,0);
		//private var weaponData:WeaponSkins = new WeaponSkins(0,0);
		// 2.
		//create bitmap with transparent canvas. This is what we see.
		private var displayData:BitmapData = new BitmapData(32,32,true,0x00000000);
		private var display:Bitmap = new Bitmap(displayData);
		// 3.
		//copy the selected area of the spriteSheet to our display bitmap
		private var tile:uint = 32; // select size
		//private var aPos:int = 0;	// postion or frame of current anim
		private var aFlag:Boolean = false;	// postion or frame of throwing anim
		private var aStat:int = 0;  // State of hero, chooses which anim to play
		private var aMax:int = 2;   // maximum anim frames in that state. (for loop terminator)
		private var heroPaste:Rectangle = new Rectangle(0,0,tile,tile); //paste
		//when we animate, we only have to update our copy rectangle.
		private var heroCopy:Rectangle = new Rectangle(aPos*tile,aStat*tile,tile,tile); //copy
		private var heroBytes:ByteArray = animData.getPixels(heroCopy); // the pixels in the heroDisplay
		private var colliders:Array = new Array();  // temporary storage for all our colliders
		
		private var keyboardStatus:Array = new Array();
		
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
			//trace("hero loaded");
			keys.addEventListener(KeyMap.KEY_UP, onKeyRelease);
			//addChild(hat);
			skinHero();
		}
		
		public override function update():void {
		    moveMe();
		}
		
		// keeps anim going if it needs to
		private function onKeyRelease(evt:Event):void{
			aFlag = true;
		}
		//show some skin
		private function skinHero() {
			//reset array pointer (necessary so we can read array from beginning)
			heroBytes.position = 0;
			displayData.setPixels(heroPaste,heroBytes);
			//adjust bitmap positio in sprite
			display.y = -32;
			display.x = -8;
			//make more biggerrer
			display.scaleX = 1;
			display.scaleY = 1;
			//plop it on stage for all to see
			this.addChild(display);
		}
		//updates the copy rectangle
		// based on hero state and player actions
		/*private function animate(act:String = null):void{
			/*****************************************************/
			//TODO: have actions also check for aMax;
			//it gets set, but never used
			/****************************************************/
			//if the player is dormant
			/*if(act == null){
				aPos++;
			}else
			if(act == 'duck'){
				aMax = 2;
				if(ldir){
					//trace('ducking right');
					aStat = 4;
				}else{
					//trace('ducking left');
					aStat = 5;
				}
				//slow anim
				if(!(frame % 2)){
					aPos++;
				}
				//if not animating, start animating
				if(!(frame % 4)){
					frame = 0;
					aPos = 2;
				}
			}else
			if(act == 'throw'){
				aMax = 2;
				aFlag = true;
				if(ldir){
					//trace('throwing right');
					aStat = 6;
				}else{
					//trace('throwing left');
					aStat = 7;
				}
				//slow anim
				if(!(frame % 2)){
					aPos++;
				}
				//if not animating, start animating
				if(!(frame % 4)){
				//useWeapon();
					frame = 0;
					aPos = 1;
				}
			}else
			if(act == 'fall'){
				aMax = 3
				frame = 0;
				if(ldir){
					//trace('falling right');
					aStat = 2;
					aPos = 2;
				}else{
					//trace('falling left');
					aStat = 3;
					aPos = 2;
				}
			}else
			if(act == 'walk'){
				aMax = 6;
				if(ldir){
					//trace('walking right');
					aStat = 0;
				}else{
					//trace('walking left');
					aStat = 1;
				}
				//if not animating, start animating
				if(!(frame % 16)){
					frame = 1;
					aPos = 1;
					//aFlag = false;
				}
				//slow anim
				if(!(frame % 4)){
					//trace('step');
					aPos++;
				}
			}else
			if(act == 'stand'){
				frame = 0;
				aPos = 0;
			}
			if(aPos >= aMax){
				aPos = aMax;
				aFlag = false;
			}
			
			//advance the 'copy' rectangle
			//and update bitmap with new data
			frame++;
			heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
			heroBytes = animData.getPixels(heroCopy);
			heroBytes.position = 0;
			displayData.setPixels(heroPaste,heroBytes);
		}*/
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
		        this.vely = 0;
		        this.y = observer.y;
		        myStatus = 'STANDING';
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
					this.y -= Yspeed;
					this.vely = -jumpHeight;
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
    			        break;
    			    case 'FALLING':
    			        walkEnabled = true;
    			        jumpEnabled = false;
    			        shootEnabled = false;
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
				this.velx -= fric;
			} else if (this.velx < 0) {
				this.velx += fric;
			}
			
		}
		
		public function moveMe():void {
		    
			applyPhysics(); // apply our enviromental variables
			updateStatus(); // update our status variable since physics update
			readInput(); // read our keyboard input and apply what is valid
		
			this.y += vely; // update our y variable
			this.x += velx; // update our x variable
			notifyObservers(); // tell everybody where we are now
		}
		
		
	}
}