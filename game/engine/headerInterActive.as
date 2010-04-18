package
{
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import pixelWalk;

	public class headerInterActive extends MovieClip
	{
		public var displayData:BitmapData = new BitmapData(760,66,true,0x000066CC);
		public var display:Bitmap;
		public var control:KeyMapping = new KeyMapping();
		//because pixelWalk is subclass of bitmapData,
		//we can treat it as such
		public var animData:pixelWalk = new pixelWalk(0,0);
		//
		private var hTile:uint = 48;
		private var vTile:uint = 0;
		public var animPosition:int = 24;
		public var heroFrame:Rectangle = new Rectangle(0,0,hTile,hTile);
		public var animFrame:Rectangle = new Rectangle(animPosition,0,hTile,hTile);
		public var heroBytes:ByteArray = new ByteArray();
		
		public function headerInterActive():void
		{
			//create the place to show everything
			display = new Bitmap(displayData);
			addChild(display);
			//add keyboard controls
			addChild(control); 
			//and GO!
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		public var i:uint = 0;
		private function onFrame(evt:Event):void
		{
			//get firstframe of animation (copy selection)
			heroFrame = new Rectangle(hTile*this.i,vTile,hTile,hTile);
			heroBytes=animData.getPixels(heroFrame);
			
			//reset array pointer (necessary)
			heroBytes.position = 0;
			
			//Right
			if((animPosition < stage.mouseX-5) && (animPosition <= stage.stageWidth-28)){ // 28??
				animWalk(true);
			}//Left
			else if((animPosition > stage.mouseX+5) && (animPosition >= 25)){
				animWalk(false);
			}//stand
			else{
				this.i =4;
			}
			//update display bmp (paste selection)
			animFrame = new Rectangle(animPosition-24,0,hTile,hTile);
			displayData.setPixels(animFrame,heroBytes);
			
			//easy way to add whole images, anywhere in display bmp
			//displayData.draw(animData,null,null,null,heroFrame);
			
		}//end onFrame
		
		private function animWalk(dir:Boolean):void
		{
			//update anim frame (copy selection)
			this.i++;
			if(this.i>=4){this.i=0};
			//update bytes (paste selection)
			if(dir){
				vTile = 0;
				animPosition +=5;
			}else{
				vTile = 48;
				animPosition -=5;
			}
		}
	}//end class
}//end package