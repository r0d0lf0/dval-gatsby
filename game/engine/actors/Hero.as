package engine.actors{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.events.Event;
	import controls.KeyMap;
	import engine.actors.Weapon;

	public class Hero extends MovieClip {
		//CHANGE THESE
		public var jumpHeight:uint = 24; //exponential. 20 jumps 3x higher than 10
		public var Yspeed:Number = 2;  //how much the velocity changes on each frameEvent
		public var Xspeed:Number = 1.4;
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
		// 1.
		//HeroSkin is subclass of bitmapData. this loads the SpriteSheet into memory
		private var animData:HeroSkin = new HeroSkin(0,0);
		private var weaponData:WeaponSkins = new WeaponSkins(0,0);
		// 2.
		//create bitmap with transparent canvas. This is what we see.
		private var displayData:BitmapData = new BitmapData(32,32,true,0x00000000);
		private var display:Bitmap = new Bitmap(displayData);
		// 3.
		//copy the selected area of the spriteSheet to our display bitmap
		private var tile:uint = 32; // select size
		private var aPos:int = 0;	// postion or frame of current anim
		private var aFlag:Boolean = false;	// postion or frame of throwing anim
		private var aStat:int = 0;  // State of hero, chooses which anim to play
		private var aMax:int = 2;   // maximum anim frames in that state. (for loop terminator)
		private var heroPaste:Rectangle = new Rectangle(0,0,tile,tile); //paste
		//when we animate, we only have to update our copy rectangle.
		private var heroCopy:Rectangle = new Rectangle(aPos*tile,aStat*tile,tile,tile); //copy
		private var heroBytes:ByteArray = animData.getPixels(heroCopy); // the pixels in the heroDisplay
		
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
			skinHero();
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
			display.y = -64;
			display.x = -16;
			//make more biggerrer
			display.scaleX = 2;
			display.scaleY = 2;
			//plop it on stage for all to see
			this.addChild(display);
		}
		//updates the copy rectangle
		// based on hero state and player actions
		private function animate(act:String = null):void{
			/*****************************************************/
			//TODO: have actions also check for aMax;
			//it gets set, but never used
			/****************************************************/
			//if the player is dormant
			if(act == null){
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
		}
		/*//make hat from existing texture resource
		private function hat():Sprite{
			var p:Point = localToGlobal(new Point(0,-32));
			var hatCopy = new Rectangle(12,0,11,3);
			var hatBytes = animData.getPixels(hatCopy);
			hatBytes.position = 0;
			var hatPaste:Rectangle = new Rectangle(0,0,11,3); //paste
			var displayHat:BitmapData  = new BitmapData(11,3,true,0x00000000);
			displayHat.setPixels(hatPaste,hatBytes);
			var hat:Bitmap = new Bitmap(displayHat);
			hat.scaleX = 3;
			hat.scaleY = 3;
			var atk:Sprite = new Sprite();
			atk.addChild(hat);
			atk.x = p.x;
			atk.y = p.y;
			return atk;
		}
		private function useWeapon():void{
			//add weapon attack
			var h = hat();
			var t = stage.getChildByName('map');
			h.x -= t.x-velx;
			h.y -= t.y+vely;
			t.addChild(h);
			if(ldir){
				h.addEventListener(Event.ENTER_FRAME,rtFrm);
			}else{
				h.addEventListener(Event.ENTER_FRAME,ltFrm);
			}
			h.addEventListener(Event.REMOVED_FROM_STAGE,htRemove);
		}
		//shoot right
		private function rtFrm(evt:Event):void{
			evt.target.x += 11;
		}
		//shoot left
		private function ltFrm(evt:Event):void{
			evt.target.x -= 11;
		}
		//free resorces at end of hat
		private function htRemove(evt:Event):void{
			try{
				evt.target.removeEventListener(Event.ENTER_FRAME,rtFrm);
			}finally{
				evt.target.removeEventListener(Event.ENTER_FRAME,ltFrm);
			}
			evt.target.removeEventListener(Event.REMOVED_FROM_STAGE,htRemove);
		}*/
		//move avatar
		public function moveMe():void {
			
			// velocitize y (gravity)
			if (this.vely < MAX_VEL_Y) {
				this.vely += this.Yspeed;
			}
			
			// de-velocitize x (friction)
			if (this.velx > 0) {
				this.velx -= fric;
			}else if (this.velx < 0) {
				this.velx += fric;
			}
			
			/**************************************************/
			//State 1. -- Falling
			/**************************************************/
			if(!imon){
				// CTRL key 
				if (KeyMap.keyMap[17]) {
					//allow throw while moving
					// A or LEFT_ARROW move left
					// D or RIGHT_ARROW move right
					if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
						if(this.velx < MAX_VEL_X){
							this.velx += this.Xspeed;
						}
						this.ldir = true;
					}else
					// A or LEFT_ARROW move left
					if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
						if(this.velx > (MAX_VEL_X*-1)){
							this.velx -= this.Xspeed;
						}
						this.ldir = false;
					}
					animate('throw');
				}else
				// D or RIGHT_ARROW move right
				if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					if(this.velx < MAX_VEL_X){
						this.velx += this.Xspeed;
					}
					this.ldir = true;
					animate('fall');
				}else
				// A or LEFT_ARROW move left
				if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					if(this.velx > (MAX_VEL_X*-1)){
						this.velx -= this.Xspeed;
					}
					this.ldir = false;
					animate('fall');
				}else
				if (!chkeys()){
					animate('fall');
				}
			}else
			
			/**************************************************/
			//State 2. -- Standing
			/**************************************************/
			{
				// CTRL key 
				if (KeyMap.keyMap[17]) {
					animate('throw');
				}else
				// SPACEBAR or UP_ARROW jump 
				if (KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
					// -speed breaks the moving platform buffer s well as still platforms.
					this.y -= Yspeed;
					this.vely = -jumpHeight;
					imon = false;
				}else
				/**************************************************/
				//Sub-State 2.1. -- Ducking
				/**************************************************/
				// S key or DOWN_ARROW duck 
				if (KeyMap.keyMap[83] || KeyMap.keyMap[40]) {
					//allow turnaround while ducking
					// A or LEFT_ARROW move left
					if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					this.ldir = true;
					}else
					// A or LEFT_ARROW move left
					if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
						this.ldir = false;
					}
					animate('duck');
				/**************************************************/
				}else
				// D or RIGHT_ARROW move right
				if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					if(this.velx < MAX_VEL_X){
						this.velx += this.Xspeed;
					}
					this.ldir = true;
					animate('walk');
				}else
				// A or LEFT_ARROW move left
				if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					if(this.velx > (MAX_VEL_X*-1)){
						this.velx -= this.Xspeed;
					}
					this.ldir = false;
					animate('walk');
				}else
				if (!chkeys()){
					if (aFlag){
						//trace('animatine');
					 	animate();
					}else if(velx == 0){
						animate('stand');
					}else if (velx != 0){
						animate('walk');
						}
				}
				//the cure for NAS (Nerve Attenuation Syndrom)  if you don't believe me, comment it out.
				if(Math.abs(velx) <= (0.1+Xspeed-fric)){velx = 0;}
				//assume we are no longer on something, in case 
				//we fell off a moving plat or something
				ihit = false;
				imon = false;
			}
		}
		
		//check if any keys are pressed. (helper function)
		private function chkeys():Boolean {
			var tmp:Boolean = false;
			for(var i:String in KeyMap.keyMap){
				if(KeyMap.keyMap[i]){tmp = true;}
			}
			return tmp;
		}
	}
}