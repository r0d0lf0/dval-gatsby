package engine.levels{
	
	//import flash.display.MovieClip;
	import engine.Level;
	import engine.screens.*;
	import engine.Screen;
	import managers.MapManager;
	import managers.TimerManager;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import engine.ISubject;
	import engine.IObserver;
	import engine.Map;
	import engine.actors.player.Hero;
	
	public class Level2 extends Level {
	    
	    private var music:music_level2;
	    private var musicChannel:SoundChannel;
	    private var myTransform:SoundTransform;
	    
		public function Level2():void{
		    mapList = new Array('level2_map1'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 2";
			levelName = "TRAIN TO THE CITY";
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
			addChild(currentScreen); // and attach it to the stage
		}
		
		public override function update(evt = null):Boolean {
		    if(!currentScreen.update()) { // update the current screen to see if it's finished
		        switch(currentScreen.getStatus()) {
		            case COMPLETE: // if our map returned COMPLETE
		                currentMapIndex++; // increment the current map index
		                if(currentMapIndex == 1) {
		                    startMusic();
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
		
		private function startMusic() {
		    music = new music_level2();  // create an instance of the music
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
		            return new level2_map1();
		    }
		    return false;
		}
				
	}//end class
}//end package