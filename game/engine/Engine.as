package engine{

    import flash.ui.Keyboard;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.display.StageDisplayState;
    import flash.display.MovieClip;
    import flash.events.*;
    import engine.ScoreboardDisplay;
    import engine.Scoreboard;
    import managers.ScreenManager;
    import engine.IObserver;
    import engine.screens.*;
    import engine.Screen;
    
    dynamic public class Engine extends Screen {
	
	private var screenManager:ScreenManager;
	private var scoreboard:Scoreboard;
	private var currentScreen;
	private var currentScreenIndex:Number = 0;
	private var playerScore:Number = 0;
	private const playerLives:Number = 3;
	private var gameMask = new game_mask();
	
	static private var screenList:Array = new Array('GameOpen','Level1','CutScene1','Level2','CutScene2','Level3','CutScene3','Level4','GameEnding');
	
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
	    stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
	    scoreboard = Scoreboard.getInstance();
	    start();
	}


	public function keyDownHandler(evt) {
	    if(evt.keyCode == 70) {
		goFullScreen();
	    }
	}

	public function goFullScreen():void {
	    if (stage.displayState == StageDisplayState.NORMAL) {
		stage.displayState=StageDisplayState.FULL_SCREEN;
	    } else {
		stage.displayState=StageDisplayState.NORMAL;
	    }
	}



	//Now we can go about our daily business of adding button handlers.
	//this is everything we would normally do.
	public function start():void {
	    screenManager = new ScreenManager(); // create our ScreenManager, basically a factory class
	    addChild(gameMask);
	    currentScreen = screenManager.getScreen(screenList[0]); // create an instance of our first screen
	    currentScreen.mask = gameMask;
	    addChild(currentScreen); // add it to the stage

	    this.addEventListener(Event.ENTER_FRAME, update); // attach onEnterFrame to onFrame
	    trace('Engine Started.'); 
	    updateStatus(ACTIVE);
	}
	
	override public function update(evt = null):Boolean{
            if(!currentScreen.update()) {  // if our current screen returns false
                switch(currentScreen.getStatus()) {  // find out why and react
                    case COMPLETE: // our screen completed successfully
                    currentScreen.alpha = 0;
                    removeChild(currentScreen); // remove the current screen from the stage
                    currentScreen.stop();
		    currentScreen = null;
                    currentScreenIndex++; // increment our index
                    if(currentScreenIndex >= screenList.length) {  // if we're out of screens
                        if(!scoreboard.getDeathCount()) { // check for bonus conditions
			    if(scoreboard.getMoneyBagCount() < 9) {
                                currentScreen = screenManager.getScreen("TrainEnding");
                                if(currentScreen is ISubject) {
				    currentScreen.addObserver(this);
                                }
			    } else {
				currentScreen = screenManager.getScreen("GraveyardEnding");
				if(currentScreen is ISubject) {
				    currentScreen.addObserver(this);
				}
			    }
                            addChild(currentScreen); // and add it to the stage
                        }
                    } else { // otherwise
                        currentScreen = screenManager.getScreen(screenList[currentScreenIndex]); // load the next screen into our current screen, so the next onEnterFrame will be the first onEnterFrame for currentLevel 
                        if(currentScreen is ISubject) {
                            currentScreen.addObserver(this);
                        }
                        addChild(currentScreen); // and add it to the stage
                    }
		    currentScreen.mask = gameMask;
                    break;
                    case HERO_DEAD: // if our hero died
                    scoreboard.removeLife(); //
                    if(scoreboard.getLives() <= 0) { // if we're out of lives
                        removeChild(currentScreen);
                        currentScreen = new GameOver();
                        addChild(currentScreen);
                    } else { // if he still has at least one life
			var currentCheckpoint = currentScreen.getMapIndex();
                        removeChild(currentScreen); // remove the current screen
                        currentScreen = screenManager.getScreen(screenList[currentScreenIndex]); // recreate the current screen
                        currentScreen.addObserver(this); // subscribe to it
			currentScreen.setMapIndex(currentCheckpoint);
                        addChild(currentScreen); // and add it to the stage
                    }
                    break;
                    case GAME_OVER: // if the game's over
                    removeChild(currentScreen);
                    currentScreenIndex = 0;
                    scoreboard.setLives(playerLives);
		    scoreboard.setScore(0);
                    currentScreen = screenManager.getScreen(screenList[currentScreenIndex]); // create an instance of our first screen
            	    addChild(currentScreen); // add it to the stage
                    break;
                }
            }
            return true;
	}
	
    }//end class
}//end package