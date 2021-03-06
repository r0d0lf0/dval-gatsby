﻿package engine.actors {
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
        
        // Define some constants for our sprite sheets
        public static const STAND:uint = 0;
        public static const WALK:uint = 1;
        public static const JUMP:uint = 2;
        public static const FALL:uint = 3;
        public static const DUCK:uint = 4;
        public static const THROW:uint = 5;
        public static const DIE:uint = 6;
        
        protected var action:uint = 0;
		protected var frame:uint = 0;
		public var count:int = 0; //the every nth frame
		public var tile:uint = 16; // select size
		public var tilesWide = 2;
		public var tilesTall = 2;
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
		
		public var mySkin:String = "GenericEnemySkin";
        public var myName:String = "GenericEnemy";
        
        protected var frameDelay:Number = 0; // number of frames 
		protected var frameCount:Number = 0; // current frame count

		//
		//public var aBytes:ByteArray = animData.getPixels(animCopy); // the pixels in the aDisplay
        
        public var startFrame = 0; // the first frame to loop on
        public var endFrame = 0; // the final frame in the row
        public var nowFrame = 0; // current frame in row
        public var loopFrame = 0; // frame at which to loop
        public var loopType = 1; // 0 loops, 1 bounces
        public var loopRowOffset = 0; // this is good i hope
        public var loopRow = 0; // which row are we on
        public var loopDir = 1; // loop forward (to the right) by default
        public var speed = 10; // how many frames should go by before we advance
        protected var frameCounter = 0;
        private var skinSetFlag = false;
    
		public function Animatable():void{
            // nothing to see here
		}
		
		override public function buildObject():void {
		    onStage = true;
		    setup();
		    setSkin(mySkin,tilesWide,tilesTall);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

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
			try {
			    displayData.setPixels(aPaste,aBytes);
			} catch(error:Error) {
			    trace("some sort of problem drawing a sprite");
			}
			
			if(display != null) {
			    try {
    			    removeChild(display);
    			} catch (error:TypeError){

    			}
			}
			//adjust bitmap positio in sprite
			display = new Bitmap(displayData);
			if(!skinSetFlag) {
			    this.y -= tilesTall * tile;
			}
			//plop it on stage for all to see
			this.addChild(display);
			skinSetFlag = true;
		}
		
		//status is which anim we are playing
		public function setStatus(status:int):void{
			this.action = status;
			//nowFrame = 0;
		}
		
		//number of pixels to advance each tile
		public function setTile(size:int=16):void{
			this.tile = size;
		}
		
		public function animate():void{
			if(frameCounter < speed) {
			    frameCounter++;
			} else {
			    frameCounter = 0;
			    aCopy = getCurrentFrame();  // this is the rectangle frame
			    
		        aBytes = animData.getPixels(aCopy); // here are the bytes of that rectangle on top of our spritesheet
    			//reset array pointer (necessary so we can read array from beginning)
    			aBytes.position = 0;
    		    displayData.setPixels(aPaste,aBytes);
                incrementFrame();
			}            
		}
		
		private function getCurrentFrame() {
		    return getRectangle((loopRow + loopRowOffset) + goingLeft, nowFrame);
		}
		
		public function getRectangle(row, frame) {
		    var xPos = frame * tile * tilesWide;  // calculate our tile's x position
		    var yPos = row * tile * tilesTall; // and its y position
		    return new Rectangle(xPos, yPos, tile * tilesWide, tile * tilesTall);  // and get a rectangle the right size and position
		}
		
		override public function update():void {
		    if(onStage) {
		        animate(); // the most basic animatable sprite will only animate
		    }
		}
		
		private function incrementFrame() {
		    if(loopType == 0) { // if were looping in a circle
		        nowFrame++; // increment our frame
		        if(nowFrame > endFrame) { // if we're past the end frame
		            nowFrame = loopFrame; // nowFrame = the frame to loop back to
		        }
		    } else if(loopType == 1) { // if we're bouncing
		        if(loopDir) { // and we're going to the right
		            nowFrame++; // increment our frame
		            if(nowFrame > endFrame) { // and we're at the last frame
		               nowFrame = endFrame - 1; // go one frame backwards 
		               loopDir = 0; // and set our loop direction to reverse
		            }
		        } else { // if we're going in reverse
		            nowFrame--; // decrement our current frame
		            if(nowFrame < loopFrame) { // if we're past the loop frame
		                nowFrame = loopFrame + 1; // put us in the right spot
		                loopDir = 1; // and change our loop direction
		            }
		        }
		    }
		    if(nowFrame < 0) {
		        nowFrame = 0;
		    }
		}
		
		public function setLoop(loopRow, startFrame, endFrame, loopFrame, loopType, speed = 10) {
		    this.loopRow = loopRow;
		    this.startFrame = startFrame;
		    this.endFrame = endFrame;
		    this.loopFrame = loopFrame;
		    this.speed = speed;
		    this.loopType = loopType;
		    nowFrame = startFrame;
		    frameCounter = speed;
		    animate();
		}
		
	}//end class
}//end package