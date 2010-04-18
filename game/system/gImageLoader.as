
package system
{
	// import dependencies
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public dynamic class gImageLoader extends Sprite {
		
		private var fileLoader:Loader;
		private var fileToLoad:URLRequest;
		
		public function gImageLoader(success:Function, failure:Function):void {
			// set data handling objects
			_init(success, failure);
		}
		
		private function _init(success:Function, failure:Function):void {
			this.fileLoader = new Loader();
			this.fileLoader.addEventListener(Event.COMPLETE, success);
			this.fileLoader.addEventListener(IOErrorEvent.IO_ERROR, failure);
		}
		 
		public function load(file:String):void {
			this.fileToLoad = new URLRequest(file);
			this.fileLoader.load(fileToLoad);
		}
	}
}