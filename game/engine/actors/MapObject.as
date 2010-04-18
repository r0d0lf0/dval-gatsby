package engine.actors{

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import system.ImageLoader;

	dynamic public class MapObject extends Sprite {

		public var unit:uint = 16;
		public var ID:uint;
		public var w:uint=1;
		public var h:uint=1;
		public var init:int = 0;
		public var bitDaty:BitmapData;

		public var imgLdr = new ImageLoader(txtureLoadSuccess,textureLoadFail);
		//public var imgLdr:ImageLoader;
		//
		public function MapObject(w,h,tex = null) {
			//trace("map object loaded");
			this.w = w;
			this.h = h;
			//this.init = init;
			doTexture(tex);
		}
		public function doTexture(tex):void {
			//written this way for levelEDitor compatibility;
			if (tex != null && tex != undefined && tex!= '') {
				imgLdr.load(tex);
				//trace(tex);
			} else {
				textureLoadFail();
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
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),false,0xFFFFFF);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		public function behave(characterObject,map):void {
			//
		}
	}
}
