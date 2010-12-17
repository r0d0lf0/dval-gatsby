package engine.actors {
    import engine.actors.Actor;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
    
    // Generic class for a MapObject that is able to be animatable.  MapObject should be the first class, this second, then different
    // moving blocks/aes/baddies should extend this.
    //
    // this will give animation methods to actors, so with basic commands like animate(start, end, loop/bounce/plannstop)
    
    public class Animatable extends Actor {
        
        protected var action:uint = 0;
		protected var frame:uint = 0;
		public var count:int = 0; //the every nth frame
		public var tile:uint = 16; // select size
		public var horzT:int = 1;
		public var vertT:int = 1;
		public var aMax:int = 6;   // maximum anim frames in that state. (for loop terminator)public var aPaste:Rectangle = new Rectangle(0,0,tile,tile); //paste
		//when we animate, we only have to update our copy rectangle.
		public var aBytes:ByteArray; // the pixels in the heroDisplay
		public var animData:BitmapData;
		public var display:Bitmap;
		public var displayData:BitmapData;
		public var aCopy:Rectangle;
		public var aPaste:Rectangle;
		//
		//public var aBytes:ByteArray = animData.getPixels(animCopy); // the pixels in the aDisplay
        
    
		public function Animatable():void{
			//
		}
		//Animatable assumes that there is a sprite sheet to be animated
		//length of teh animatio, frame to loop at 
		public function setLoop(len:int=-1,rep:int = 0):void{
			//if our playhead is greater than the anim cycle:
			//set to beginnign of loop
			if(len>=0){
				if(this.frame>= len){
					this.frame = rep;
				}
			}
		}//end animate
		
		//handles loading textures in the library
		public function setSkin(tex:String,w:int,h:int):void {
			
			horzT = w;
			vertT = h;
			
			var ClassReference:Class = getDefinitionByName(tex) as Class;
			animData = new ClassReference(0,0);
			displayData = new BitmapData(tile*w,tile*h,true,0x00000000);
			aCopy = new Rectangle(frame*tile*w,action*tile*h,tile*w,tile*h); //copy
			aPaste = new Rectangle(0,0,tile*w,tile*h); //paste
			
			
			aBytes = animData.getPixels(aCopy);
			//reset array pointer (necessary so we can read array from beginning)
			aBytes.position = 0;
			displayData.setPixels(aPaste,aBytes);
			//adjust bitmap positio in sprite
			display = new Bitmap(displayData);
			display.y = -32;
			display.x = -8;
			//plop it on stage for all to see
			this.addChild(display);
			//return wClass;
		}
		//status is which anim we are playing
		public function setStatus(status:int):void{
			this.action = status;
		}
		//number of pixels to advance each tile
		public function setTile(size:int=16):void{
			this.tile = size;
		}
		public function animate(act:String = null):void{
			//trace(frame);
			if(frame*tile >= aMax*tile){
				frame = 1;
			}
			aCopy = new Rectangle(frame*tile*horzT,action*tile*vertT,tile*horzT,tile*vertT); //copy
			//trace('copy:  '+aCopy);
			aBytes = animData.getPixels(aCopy);
			//reset array pointer (necessary so we can read array from beginning)
			aBytes.position = 0;
			displayData.setPixels(aPaste,aBytes);
			frame++;
		}
	}//end class
}//end package