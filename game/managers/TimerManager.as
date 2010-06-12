package managers{

	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class TimerManager {

		private var time:int = 0;
		
		public function TimerManager():void {
			
		}
		
		
		static public function wait(t:int, m:Function){
			
            var myTimer:Timer = new Timer(1000*t, 0);
            myTimer.addEventListener("timer", m);
            myTimer.start();
		}
		static public function loop(t:int, c:int, m:Function){
			
            var myTimer:Timer = new Timer(1000*t, c);
            myTimer.addEventListener("timer", m);
            myTimer.start();
		}
		
        public function timerHandler(event:TimerEvent):void {
            trace("timerHandler: " + event);
        }
	}//end class
}//end package
