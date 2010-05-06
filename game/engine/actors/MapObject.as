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
		//public var bitDaty:BitmapData;
		private var hero:*;
		//so nice
		public var imgLdr = new ImageLoader(txtureLoadSuccess,textureLoadFail);
		//The constructor 
		// initialize instance variables and see 
		// if its 'safe' to add listeners.
		public function MapObject(w,h,tex = null) {
			//trace("map object loaded");
			this.w = w;
			this.h = h;
			this.tex = tex;
			//Check for instance of self
			if (stage != null) {
				buildObject();
			} else { // wait till we exist in Flash spacetime
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildObject();
		}
		//initialize object after it's on stage
		public function buildObject() {
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
			//if tex is null, just load a charle (white square)
			if (tex != null && tex != undefined && tex!= '') {
				imgLdr.load(tex);
			} else {
				textureLoadFail();
			}
		}
		//check if the thing hit the Hero
		//look up "Axis based collisions"
		private function onFrame(evt:Event):void{
			
			var hero:* = stage.getChildByName('hero');
			var hhw = hero.width/4;
			//move it with the map
			this.me = localToGlobal(new Point(0,0));
			var mhw = this.width/2;
			
			var dx = (me.x+mhw) - (hero.x+hhw+hero.velx+10);
			var ox = (hhw+mhw) - Math.abs(dx);
			//if x: set up y check
			if(ox > 0){
				var hhh = hero.height/2;
				var mhh = this.height/2;
				var dy = (me.y+mhh) - (hero.y-hhh+hero.vely+hero.speed);
				var oy = (hhh+mhh) - Math.abs(dy);
				//if y: it's a hit
				if(oy > 0){
					behave({dx:dx,ox:ox,dy:dy,oy:oy},hero);
					hero.ihit = true;
				}
			}
		}
		//show the background image
		public function txtureLoadSuccess(evt:*) {
			var tmpData:BitmapData = evt.target.content.bitmapData;
			var tmp:Bitmap = new Bitmap(tmpData);
			tmp.scaleX = 2;
			tmp.scaleY = 2;
			this.addChild(tmp);
		}
		//show blank
		public function textureLoadFail(evt:*=null) {
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),true,0x00FFFFFF);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		public function behave(smackData:Object, characterObject:*):void {
			//this is overwritten by each unique subclass
		}
	}
}
