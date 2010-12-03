package engine.levels{
	
	//import flash.display.MovieClip;
	import engine.Level;
	import engine.screens.*;
	import managers.MapManager;
	import managers.TimerManager;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import engine.Map;
	import engine.actors.player.Hero;
	
	public class Level1 extends Level {
	    
	    private var music:music_level1;
	    private var musicChannel:SoundChannel;
	    private var myTransform:SoundTransform;
	    
		public function Level1():void{
		    mapList = new Array('level1_map1', 'level1_map2', 'level1_map3'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 1";
			levelName = "GATSBY'S PARTY";
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
			addChild(currentScreen); // and attach it to the stage
		}
		
		override public function update(evt = null):Boolean {
		    if(!currentScreen.update()) { // update the current screen to see if it's finished
		        switch(currentScreen.getStatus()) {
		            case COMPLETE: // if our map returned COMPLETE
						if(currentScreen is LevelStart) { // if we just finished the LevelStart screen
							startMusic(); // then it's time to start the music
						}
		                currentMapIndex++; // increment the current map index
		                if(currentMapIndex < (mapList.length + 1)) { // and if we haven't finished the last map
		                    myKeys.removeObserver(currentScreen); // unsubscribe it from the KeyMap
		                    currentScreen.alpha = 0; // make the current map invisible invisible
		                    removeChild(currentScreen); // and remove it from the stage
		                    currentScreen = getMap(currentMapIndex);  // get the next one
		                    addChild(scoreboardDisplay); // add the scoreboard
                            addChild(currentScreen); // add the new child
                            currentScreen.y += scoreboardDisplay.height; // move the screen down so that it doesn't cover the scoreboard
		                } else { // otherwise, we've completed the final map so
		                    stopMusic(); // stop the music
		                    removeChild(currentScreen); // get rid of the current screen
		                    updateStatus(COMPLETE);  // set the level exit status to COMPLETE
		                    return false; // and return false to the Engine
		                }
		                break;
		            case HERO_DEAD: // if the map returns HERO DEAD
		                updateStatus(HERO_DEAD);  // set the level exit status to HERO DEAD
		                stopMusic(); // stop our music
		                return false; // and return false to the Engine
		                break;
		        }
		    }
		    // otherwise, if the map returned true
		    return true;  // then so will the level
		}
		
		private function startMusic() {
		    music = new music_level1();  // create an instance of the music
		    musicChannel = music.play(0, 100);  // play it, looping 100 times
		    myTransform = new SoundTransform(.35, 0);
		    musicChannel.soundTransform = myTransform;
		}
		
		private function stopMusic() {
		    if(musicChannel) {
		        musicChannel.stop();
		    }
		}

		private function getMap(mapIndex) {
		    switch(mapIndex) {
		        case 1:
		            return new level1_map3();
		        case 2:
		            return new level1_map2();
		        case 3:
		            return new level1_map3();
		    }
		    return false;
		}
		
	}//end class
}//end package