package system{
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	public class TextLoader extends EventDispatcher {
		
		public var fileWrapper:URLLoader = new URLLoader();
		public var data:String = "";

		public function TextLoader() {
			makeListener(fileWrapper);
		}
		private function makeListener(eventDispatcher:IEventDispatcher) {
			// match event with custom Event handler
			eventDispatcher.addEventListener(Event.COMPLETE, onComplete);
		}
		public function onComplete(event:Event) {
			this.data = event.target.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function loadFile(fileName:String) {
			var contentRequest:URLRequest = new URLRequest(fileName);
			fileWrapper.load(contentRequest);
		}
	}
}