package engine{
	
	import flash.display.MovieClip;
	import controls.KeyMap;
	import flash.events.*;
	import flash.events.Event;
	import engine.screens.*;
	import engine.Screen;
	import engine.ScoreboardDisplay;
	import engine.Scoreboard;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
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
	    
	    protected var myKeys:KeyMap = KeyMap.getInstance();
		
		protected var music;
	    protected var bossMusic;
	    protected var musicChannel:SoundChannel;
	    protected var myTransform:SoundTransform;
		
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
			buildLevel();
		}
		
		protected function startMusic() {
		    musicChannel = music.play(0, 100);  // play it, looping 100 times
		    myTransform = new SoundTransform(.35, 0);
		    musicChannel.soundTransform = myTransform;
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
	        
	        updateStatus(ACTIVE);
		}
		
		private function loadScreen(screen:MovieClip) {
		    myKeys.addSubscriber(screen);
		    this.addChild(screen);
		}
		
		override public function update(evt = null):Boolean {
		    if(!currentScreen.update()) { // update the current screen to see if it's finished
		        switch(currentScreen.getStatus()) {
		            case COMPLETE: // if our map returned COMPLETE
		                currentMapIndex++; // increment the current map index
		                scoreboard.setCurrentMap(currentMapIndex);
						if(currentScreen is LevelStart) {
							startMusic();
							scoreboard.setTimeLimit(300);
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
		                } else { // otherwise, we've completed the final map so
		                    stopMusic(); // stop the music
		                    updateStatus(COMPLETE);  // set the level exit status to COMPLETE
		                    return false; // and return false to the Engine
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
		    // otherwise, if the map returned true
		    return true;  // then so will the level
		}
		
		protected function getMap(mapIndex) {
		    return 1; // this will get overwritten
		}
		
		public function getMapIndex() {
			return currentMapIndex - 1;
		}
		
		public function setMapIndex(newIndex:Number) {
			currentMapIndex = newIndex;
		}
			
	}//end class
}//end package