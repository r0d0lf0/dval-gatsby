package engine{

	import flash.display.MovieClip;
	import flash.events.Event;
	import engine.Scoreboard;
	import engine.Subscriber;
	import managers.ScreenManager;

	dynamic public class Engine extends MovieClip{
	    
	    private var screenManager:ScreenManager;
	    private var scoreboard:Scoreboard;
	    private var currentScreen;
	    private var currentScreenIndex:Number = 0;
	    
	    private var playerScore:Number = 0;
	    private var playerLives:Number = 3;
	    
	    static private var screenList:Array = new Array('gameOpen','Level1');
		
		public function Engine():void {
			//check for flash spacetime coordinates
			if (stage != null) {
				start();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		//on stage
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			start();
		}
		//Now we can go about our daily business of adding button handlers.
		//this is everything we would normally do.
		public function start():void {
		    screenManager = new ScreenManager(); // create our ScreenManager, basically a factory class
		    currentScreen = screenManager.getScreen(screenList[0]); // create an instance of our first screen
			addChild(currentScreen); // add it to the stage
			this.addEventListener(Event.ENTER_FRAME, update); // attach onEnterFrame to onFrame
			trace('Engine Started.'); 
		}
			
		private function update(evt:Event):void{
            if(!currentScreen.update()) {  // if our current screen returns false
                switch(currentScreen.getStatus()) {  // find out why and react
                    case 'COMPLETE': // our screen completed successfully
                        removeChild(currentScreen) // remove the current screen from the stage
                        currentScreenIndex++; // increment our index
                        if(currentScreenIndex >= screenList.length) {  // if we're out of screens
                            //restart(); // game's over.  restart
                        } else { // otherwise
                            currentScreen = screenManager.getScreen(screenList[currentScreenIndex]); // load the next screen into our current screen, so the next onEnterFrame will be the first onEnterFrame for currentLevel 
                            addChild(currentScreen); // and add it to the stage
                        }
                        break;
                    case 'HERO DEAD': // if our hero died
                        playerLives--; // decrement his lives by one
                        if(playerLives <= 0) { // if we're out of lives
                            // game over
                        } else { // if he still has at least one life
                            currentScreen.restart(); // restart our level
                        }
                        break;
                }
            }
		}
	}//end class
}//end package