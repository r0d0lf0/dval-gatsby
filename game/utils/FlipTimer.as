package utils {
    
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    
    dynamic public class FlipTimer {
        
        public var timerOver:Boolean = false;
        public var flipVar;
        public var flipCaller;
        private var myTimer;
        
        public function FlipTimer(flipCaller, flipVar, delay) {
            this.flipCaller = flipCaller; // the object that called our flipper
            this.flipVar = flipVar; // this is how we need to start, we'll finish opposite
            myTimer = new Timer(delay, 1);
            myTimer.addEventListener(TimerEvent.TIMER, this.timeUp);
            myTimer.start();
        }
		
	public function timeUp(evt) {
	    flipCaller[flipVar](); // call the function we were asked
            myTimer.removeEventListener(TimerEvent.TIMER, this.timeUp); // an
	}
		
        
    }
    
    
}