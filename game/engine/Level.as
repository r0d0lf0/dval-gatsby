package engine{
	
	import flash.display.MovieClip;
	import managers.ScreenManager;
	import engine.Subscriber
	
	dynamic public class Level extends MovieClip implements ISubscriber {
	
		public function Level():void{
			
			
		}
		
		private function addSubscription(target:MovieClip):void{
			Subscriber.subscribe(this);
		}
		private function cancelSubscription(target:MovieClip):void{
			Subscriber.unsubscribe(this);
		}
		private function update():void{
			trace('running');
		}
	}//end class
}//end package