package engine.actors{

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;

	import system.ImageLoader;

	dynamic public class MapObject extends Sprite {

		public var unit:uint = 16;
		public var ID:uint;
		public var w:uint=1;
		public var h:uint=1;
		public var tex:String = '';
		protected var me:Point = localToGlobal(new Point(0,0));
		private var hero:*;
		//so nice
		public var imgLdr = new ImageLoader(textureLoadSuccess,textureLoadFail);
		//The constructor 
		// initialize instance variables and see 
		// if its 'safe' to add listeners.
		public function MapObject(w,h,tex = null):void {
			//trace("map object loaded");
			this.w = w;
			this.h = h;
			this.tex = tex;
			//Check we exist in Flash spacetime
			if (stage != null) {
				buildObject();
			} else {  
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildObject();
		}
		//initialize object after it's on stage
		public function buildObject():void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			doTexture(this.tex);
		}
		//clean up and free resources
		public function onRemove(evt:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		//handles texture and texture not found
		public function doTexture(tex):void {
			//written this way for levelEDitor compatibility
			//if tex is null, load a Charlie (It's white square! hahahaha)
			if (tex != null && tex != undefined && tex!= '') {
				imgLdr.load(tex);
			} else {
				textureLoadFail();
			}
		}
		//check if the thing hit the Hero
		//look up "Axis based collisions"
		private function onFrame(evt:Event):void{
			//hero x axis
			var hero:* = stage.getChildByName('hero');
			var hhw = hero.width/4; // Hero Half-Width
			//mapObject x axis
			this.me = localToGlobal(new Point(0,0));
			var mhw = this.width/2; // MapObject Half-Width
			//distance and overlap between them
			var dx = (me.x+mhw) - (hero.x+hhw+hero.velx+hero.Xspeed);  //distance x
			var ox = (hhw+mhw) - Math.abs(dx);  //overlap x
			/*************** Check for collision ********************/
			//if there is a collision on the X axis:
			if(ox > 0){
				//then spend resources checking for Y axis collision
				//hero Y axis
				var hhh = hero.height/2;
				//mapObject Y axis
				var mhh = this.height/2;
				//distance and overlap between them
				var dy = (me.y+mhh) - (hero.y-hhh+hero.vely+hero.Yspeed);
				var oy = (hhh+mhh) - Math.abs(dy);
				//if there is collision on Y:
				if(oy > 0){
					//we have a hit! mapObject should 'behave' accordingly
					behave({dx:dx,ox:ox,dy:dy,oy:oy},hero);
					//tell the hero he hit something (this effects animation)
					hero.ihit = true;
				}
			}
		}
		//show the background image
		public function textureLoadSuccess(evt:*):void {
			var tmpData:BitmapData = evt.target.content.bitmapData;
			var tmp:Bitmap = new Bitmap(tmpData);
			tmp.scaleX = 2;
			tmp.scaleY = 2;
			this.addChild(tmp);
		}
		//show blank
		public function textureLoadFail(evt:*=null):void {
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),true,0x00FFFFFF);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		public function behave(smackData:Object, characterObject:*):void {
			//this is overwritten by each unique subclass
		}
	}
}
