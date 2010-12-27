package engine{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import engine.screens.*;
	import engine.Screen;
	import engine.ScoreboardDisplay;
	import engine.Scoreboard;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import controls.KeyMap;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	dynamic public class Level extends Screen {
	
	    protected var stageNumber = 1;
	    protected var levelNumber:String = "LEVEL X";
	    protected var levelName:String = "UNNAMED";
	    protected var bossName:String = "BAD BOSS";
	    protected var bossHP = 0;
		protected var startedFlag:Boolean = false;
	
		protected var mapList:Array;
		protected var currentMapIndex:Number = 0;
		protected var currentScreen;
		
		protected var scoreboardDisplay:ScoreboardDisplay;
		protected var scoreboard:Scoreboard;

		protected var music;
	    protected var bossMusic;
	    protected var musicChannel:SoundChannel;
	    protected var myTransform:SoundTransform;
	    
	    protected var BUTTON_ENTER = false;
		
		protected var scoringComplete = false;
		protected var scoringStatus = 0;
		
		protected var timeConversionStarted = false;
		
		protected var pausePoint;
		
 		public function Level():void{
 		    music = new music_level1();  // create an instance of the music
			if(stage){
				buildLevel();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, initBuild);
			}
		}
		
		private function initBuild(evt:Event):void{
		    removeEventListener(Event.ADDED_TO_STAGE, initBuild);
		    addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		    addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			buildLevel();
		}
		
		public function keyDownHandler(evt):void {
		    // here's where we handle keyboard changes
		    if(evt.keyCode == Keyboard.ENTER) {
		        BUTTON_ENTER = true;
		    }
		}
		
		public function keyUpHandler(evt):void {
		    // here's where we handle keyboard changes
		    if(evt.keyCode == Keyboard.ENTER) {
                BUTTON_ENTER = false;
		    }
		}
		
		protected function startMusic() {
		    musicChannel = music.play(0, 100);  // play it, looping 100 times
		}
		
		protected function stopMusic() {
		    if(musicChannel) {
		        musicChannel.stop();
		    }
		}
		
		public function buildLevel():void{
		    scoreboardDisplay = new ScoreboardDisplay(); // create a new scoreboard display object
		    scoreboard = Scoreboard.getInstance(); // get a copy of our scoreboard
	        scoreboard.addObserver(scoreboardDisplay); // and subscribe the display to the scoreboard
	        scoreboard.setHeroHP(3);
	        scoreboard.setCurrentBoss(bossName);
	        scoreboard.setBossHP(bossHP);
	        scoreboard.setCurrentLevel(stageNumber);
	        
	        
	        var startTimer:Timer = new Timer(1000,1);
			startTimer.addEventListener(TimerEvent.TIMER, timerListener);
			startTimer.start();
			
			function timerListener (e:TimerEvent):void{
				addChild(currentScreen); // and attach it to the stage
				updateStatus(ACTIVE);
				startTimer.stop();
				pausedFlag = false;
			}
			
		}
		
		public function pauseGame() {
		    pausedFlag = true;
		    pausePoint = musicChannel.position;
		    musicChannel.stop;
		}
		
		public function unPauseGame() {
		    pausedFlag = false;
		    musicChannel = music.play(pausePoint, 100);
		}
		
		override public function update(evt = null):Boolean {
		    if(BUTTON_ENTER) {
		        if(pausedFlag) {
		            unPauseGame();
		        } else {
		            pauseGame();
		        }
		        BUTTON_ENTER = false;
		    }
		    if(!pausedFlag) {
		        if(!currentScreen.update()) { // update the current screen to see if it's finished
    		        switch(currentScreen.getStatus()) {
    		            case COMPLETE: // if our map returned COMPLETE
    		                currentMapIndex++; // increment the current map index
    		                scoreboard.setCurrentMap(currentMapIndex);
    						if(currentScreen is LevelStart) {
    							startMusic();
    							scoreboard.setTimeLimit(300);
    							scoreboard.startTimer();
    							scoreboard.setHeroHP(3);
    							scoreboard.setCurrentBoss(bossName);
    							scoreboard.setBossHP(bossHP);
    							scoreboard.setCurrentLevel(stageNumber);
    							scoreboard.setBossHP(bossHP);
    						}
    		                if(currentMapIndex < (mapList.length + 1)) { // and if we haven't finished the last map
    		                    removeChild(currentScreen); // remove the current map
    		                    currentScreen = getMap(currentMapIndex);  // get the next one
    		                    addChild(scoreboardDisplay); // add the scoreboard
                                addChild(currentScreen); // add the new child
                                currentScreen.y += scoreboardDisplay.height; // move the screen down so that it doesn't cover the scoreboard
    		                    return true; // and return true
    		                } else if(!scoringComplete){ // otherwise, we've completed the final map but we're not do
    		                    scoreboard.setCurrentMap(mapList.length);
    		                    switch(scoringStatus) {
    		                        case 0:
    		                            stopMusic(); // stop the music
    		                            scoreboard.stopTimer(); // stop the timer
    		                            var success_music = new fanfare_music(); // get us some success music
    		                            musicChannel = success_music.play(0); // and play that noise
    		                            musicChannel.addEventListener(Event.SOUND_COMPLETE, this.soundComplete); // let us know when you're done
            		                    scoringStatus = 1;
            		                    break;
            		                case 1:
            		                    break; // this is advanced by the sound finishing
            		                case 2:
            		                    pause(1000);
            		                    scoringStatus++;
            		                case 3:
            		                    if(!timeConversionStarted) {
            		                        var score_sound = new score_count_sound();
            		                        musicChannel = score_sound.play(0, 1000);
            		                    }
            		                    if(scoreboard.getCurrentTime() > 0) {
            		                        timeConversionStarted = true;
            		                        scoreboard.timeToPoints();
            		                    } else {
    		                                scoringStatus++;
            		                    }
            		                    break;
            		                case 4:
            		                    pause(1000);
            		                    musicChannel.stop();
            		                    scoringStatus++;
            		                    break;
            		                case 5:
            		                    scoringComplete = true;
            		                    break;
            		            }
    		                    return true; // and return false to the Engine
    		                } else {
    		                    updateStatus(COMPLETE);  // set the level exit status to COMPLETE
    		                    return false;
    		                }
    		                break;
    		            case HERO_DEAD: // if the map returns HERO DEAD
    		                updateStatus(HERO_DEAD);  // set the level exit status to HERO DEAD
    		                trace("Hero dead."); // debug that the hero died
    		                stopMusic(); // stop our music
    		                return false; // and return false to the Engine
    		                break;
    		        }
    		    }
		    }
		    // otherwise, if the map returned true
		    return true;  // then so will the level
		}
		
		protected function getMap(mapIndex) {
		    return 1; // this will get overwritten
		}
		
		public function soundComplete(e) {
            scoringStatus++; // when we're done, move us along
            musicChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
        }
		
		public function getMapIndex() {
			return currentMapIndex - 1;
		}
		
		public function setMapIndex(newIndex:Number) {
			currentMapIndex = newIndex;
		}
			
	}//end class
}//end package