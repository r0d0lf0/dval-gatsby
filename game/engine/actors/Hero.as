package engine.actors{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import controls.KeyMap;

	public class Hero extends MovieClip {
		public var vely:int = 0;
		public var velx:int = 0;
		public var speed:uint = 3;
		public var imon:Boolean = false;
		public var ldir:Boolean = true;
		public var jumpHeight:uint = 20;
		//create bitmap with transparent canvas
		public var display:Bitmap;
		public var displayData:BitmapData = new BitmapData(32,32,true,0x00000000);
		//HeroSkin is subclass of bitmapData. this loads the SpriteSheet into mem
		public var animData:HeroSkin = new HeroSkin(0,0);
		//
		private var tile:uint = 32; // select size
		public var animPos:int = 0;
		public var animState:int = 0;
		public var heroPaste:Rectangle = new Rectangle(0,0,tile,tile); //paste
		public var heroCopy:Rectangle = new Rectangle(0,0,tile,tile); //copy
		public var heroBytes:ByteArray = new ByteArray(); // the pixels in the heroDisplay
		
		// MAX_VEL_Y has to be less than half the height of most narrow platform.
		// otherwise you will fall through the ground
		const MAX_VEL_Y:Number = 11;
		const MAX_VEL_X:Number = 8;
		
		public function Hero() {
			textureLoad();
			trace("hero loaded");
		}
		
		//show skin
		public function textureLoad() {
			var tmp:Bitmap = new Bitmap(animData);
			display = new Bitmap(displayData);
			heroBytes = animData.getPixels(heroCopy);			
			//reset array pointer (necessary)
			heroBytes.position = 0;

			displayData.setPixels(heroPaste,heroBytes);
			/*
			tmp.scaleX = 2;
			tmp.scaleY = 2;*/
			display.y = -32;
			this.addChild(display);
		}
		private function animate():void{
			//if(vely != 3){action = 3; trace(vely );}
			//if(velx < 0){action = action +1;}
			if(action == 0){
				trace('standing');
			}
			if(action == 1){
				trace('walk right');
			}
			if(action == 2){
				trace('walk left');
			}
			if(action == 3){
				trace('jump right');
			}
			if(action == 4){
				trace('jump left');
			}
		}
		private function chkeys():Boolean {
			var tmp:Boolean = false;
			for(var i:String in KeyMap.keyMap){
				if(KeyMap.keyMap[i]){tmp = true;}
			}
			return tmp;
		}
		//
		public function moveMe() {
			// velocitize y
			if (this.vely < MAX_VEL_Y) {
				this.vely += this.speed;
			}
			
			// de-velocitize x
			if (this.velx > 0) {
				this.velx -= 1;
			}else if (this.velx < 0) {
				this.velx += 1;
			}
			
			
			// D or RIGHT_ARROW move right
			if (KeyMap.keyMap[68] || KeyMap.keyMap[39]) {
				if(this.velx < MAX_VEL_X){
					this.velx += this.speed;
				}
				if(imon){
					animate(1);
				}else{
					animate(3);
				}
			}
			// A or LEFT_ARROW move left
			if (KeyMap.keyMap[65] || KeyMap.keyMap[37]) {
				if(this.velx > (MAX_VEL_X*-1)){
					this.velx -= this.speed;
				}
				if(imon){
					animate(2);
				}else{
					animate(4);
				}
			}
			// SPACEBAR or UP_ARROW jump 
			if (KeyMap.keyMap[32] || KeyMap.keyMap[38]) {
				//if hero is on the ground...
				if (imon) {
					// -3 breaks the moving platform buffer s well as still platforms.  I don't know.
					this.y -= 3;
					this.vely = -jumpHeight;
				}
			}
			//if both player and avatar are doing nothing:
			if(!imon && !chkeys()){animate(0);}
		}
	}
}