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
    
}