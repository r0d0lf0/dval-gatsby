package engine.actors {
    import flash.display.MovieClip;
    
    // Generic class for a MapObject that is able to be animatable.  MapObject should be the first class, this second, then different
    // moving blocks/heroes/baddies should extend this.
    //
    // this will give animation methods to actors, so with basic commands like animate(start, end, loop/bounce/plannstop)
    
    public class Animatable extends MovieClip {
        
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
		private var aStat:int = 0;  // State of hero, chooses which anim to play
		private var aMax:int = 2;   // maximum anim frames in that state. (for loop terminator)private var heroPaste:Rectangle = new Rectangle(0,0,tile,tile); //paste
		//when we animate, we only have to update our copy rectangle.
		private var heroCopy:Rectangle = new Rectangle(aPos*tile,aStat*tile,tile,tile); //copy
		private var heroBytes:ByteArray = animData.getPixels(heroCopy); // the pixels in the heroDisplay
        
    }
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
}