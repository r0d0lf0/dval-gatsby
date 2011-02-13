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
	
	public class Level4 extends Level {
	    
		public function Level4():void{
		    mapList = new Array('level4_map1'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 4";
			levelName = "WEST EGG BEACH";
			stageNumber = 4;
			bossName = " ";
			bossHP = 0;
			music = new music_level4();  // create an instance of the music
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
		}

		override protected function getMap(mapIndex) {
		    switch(mapIndex) {
		        case 1:
		            return new level4_map1();
					break;
		    }
		    return false;
		}
				
	}//end class
}//end package