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
	    
		public function Level1():void{
		    mapList = new Array('level1_map3'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 1";
			stageNumber = 1;
			levelName = "GATSBY'S PARTY";
			bossName = "FIND GATSBY!";
			music = new music_level1();  // create an instance of the music
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
		}

		override protected function getMap(mapIndex) {
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