package system{

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class ImageLoader extends Sprite {

		private var fileLoader:Loader;
		private var fileToLoad:URLRequest;

		public function ImageLoader(success:Function, failure:Function):void {
			// set data handling objects
			_init(success, failure);
		}
		//
		private function _init(success:Function, failure:Function):void {
			this.fileLoader = new Loader();
			this.fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, success);
			this.fileLoader.addEventListener(IOErrorEvent.IO_ERROR, failure);
		}
		//
		public function load(file:String):void {
			this.fileToLoad = new URLRequest(file);
			this.fileLoader.load(fileToLoad);
		}
	}
}