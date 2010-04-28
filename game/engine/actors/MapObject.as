package engine.actors{

	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	import system.ImageLoader;

	dynamic public class MapObject extends Sprite {

		public var unit:uint = 16;
		public var ID:uint;
		public var w:uint=1;
		public var h:uint=1;
		public var tex:String = '';
		public var bitDaty:BitmapData;
		private var reActor:*;
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
				imgLdr.load(this.tex);
			} else {
				textureLoadFail();
			}
		}
		//NEW!
		//check if the ground hit the Hero
		private function onFrame(evt:Event):void{
			/*****************************************************/
			//TODO:  DONE
			//This is where I need to perfor the hit test rewrite
			//use distance calculations, instead of hitTestObject()
			//it has noticable performance increase
			/*****************************************************/
			
			var reActor:* = stage.getChildByName('hero');
			
			//if(this.y+this.height>=reActor.y-reActor.vely){
				//if(this.x+this.width > reActor.x && this.x < reActor.x+32){
					//now check for hit, it is only called on relevant blocks
					if(this.hitTestObject(reActor)){
						//trace(this.name);
						//hahahahah yes. I can call a blank method. and it's subclass's method is used !!
						reActor.imon = true;
						reActor.ihit = true;
						behave(reActor);
					}
				//}
			//}
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
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),true,0x88EEEE00);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		public function behave(characterObject):void {
			//this is overwritten by each unique subclass
		}
	}
}
