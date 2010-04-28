package engine.actors{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import controls.KeyMap;

	public class Hero extends MovieClip {
		//CHANGE THESE
		public var jumpHeight:uint = 20; //exponential. 20 jumps 3x higher than 10
		public var speed:Number = 2;  //how much the velocity changes on each frameEvent
		public var fric:Number = 1;  //frictional coefficient of go
		//DON'T CHANGE THESE
		public var vely:int = 0;
		public var velx:int = 0;
		public var imon:Boolean = false; // On|Off the ground = true|false (stnading sure-footedly)
		public var ihit:Boolean = false; // On|Off any object = true|false (smack a wall, hit by baddy)
		private var keys:KeyMap = new KeyMap();
		private var action:uint = 0;
		private var frame:uint = 1;
		private var ldir:Boolean = true;  // Right|Left = true|false
		// 1.
		//HeroSkin is subclass of bitmapData. this loads the SpriteSheet into memory
		private var animData:HeroSkin = new HeroSkin(0,0);
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
		
		// MAX_VEL_Y has to be less than half the height of most narrow platform.
		// otherwise you will fall through the ground
		/***********************************************************************
		//TODO: check for colision befor hitting ground. 
		//TODO's in Map.as need to be completed for this to work
		// else use as is
		/***********************************************************************/
		const MAX_VEL_Y:Number = 11; // so min platform height should be 22.
		const MAX_VEL_X:Number = 8;
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
			keys.addEventListener(KeyMap.KEY_UP, onKeyUp);
			skinHero();
		}
		private function onKeyUp(evt:Event):void{
			//trace('hopefully....');
			aFlag = true;
			aPos = 1;
		}
		//show skin
		//this is overall characteristics of displayed bitmapData
		public function skinHero() {
			//reset array pointer (necessary so we can read array from beginning)
			heroBytes.position = 0;
			//update the data in our displayed bitmap
			displayData.setPixels(heroPaste,heroBytes);
			//fix bad choices
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
			if(act == null){
				//if(aFlag){
					aPos++;
					if(aPos >= aMax){
						aPos = aMax;
						aFlag = false;
					}
				//}
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
				/********************************************************/
				//TODO: DONE!
				//FIXME
				//figure out how to stop anim loop
				/*********************************************************/
				//slow anim
				if(!(frame % 2)){
					aPos++;
				}
				//if not animating, start animating
				if(!(frame % 4)){
					frame = 0;
					aPos = 2;
				}
				//get data and advance frame
				//heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
				//frame++;
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
					trace('GO');
					aPos++;
				}
				//if not animating, start animating
				if(!(frame % 4)){
					frame = 0;
					aPos = 1;
				}
				//get data and advance frame
				//heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
				//frame++;
			}else
			if(act == 'fall'){
				frame = 0;
				if(ldir){
					//trace('falling right');
					aStat = 2;
					aPos = 2;
					//heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
				}else{
					//trace('falling left');
					aStat = 3;
					aPos = 2;
					//heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
				}
			}else
			if(act == 'walk'){
				if(ldir){
					//trace('walking right');
					aStat = 0;
				}else{
					//trace('walking left');
					aStat = 1;
				}
				//if not animating, start animating
				if(!(frame % 8)){
					frame = 1;
					aPos = 1;
					//aFlag = false;
				}
				//slow anim
				if(!(frame % 2)){
					//trace('step');
					aPos++;
				}
				//reset to first frame on loop
				/*if(!this.aFlag){
					this.aFlag = true;
					aPos = 1;
				}*/
				//get data and advance frame
				//heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
				//frame++;
			}else
			if(act == 'stand'){
				frame = 0;
				aPos = 0;
			}
			frame++;
			heroCopy = new Rectangle(aPos*tile,aStat*tile,tile,tile);
			heroBytes = animData.getPixels(heroCopy);
			heroBytes.position = 0;
			displayData.setPixels(heroPaste,heroBytes);
		}
		
		//move avatar
		public function moveMe():void {
			
			// velocitize y (gravity)
			if (this.vely < MAX_VEL_Y) {
				this.vely += this.speed;
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
					animate('throw');
				}else
				// D or RIGHT_ARROW move right
				if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					if(this.velx < MAX_VEL_X){
						this.velx += this.speed;
					}
					this.ldir = true;
					animate('fall');
				}else
				// A or LEFT_ARROW move left
				if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					if(this.velx > (MAX_VEL_X*-1)){
						this.velx -= this.speed;
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
					this.y -= speed;
					this.vely = -jumpHeight;
					imon = false;
				}else
				// S key or DOWN_ARROW duck 
				if (KeyMap.keyMap[83] || KeyMap.keyMap[40]) {
						animate('duck');
				}else
				// D or RIGHT_ARROW move right
				if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
					if(this.velx < MAX_VEL_X){
						this.velx += this.speed;
					}
					this.ldir = true;
					animate('walk');
				}else
				// A or LEFT_ARROW move left
				if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
					if(this.velx > (MAX_VEL_X*-1)){
						this.velx -= this.speed;
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