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
	
	public class Level3 extends Level {
	    
		public function Level3():void{
		    mapList = new Array('level3_map1', 'level3_map2', 'level3_map3', 'level3_map4'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 3";
			stageNumber = 3;
			levelName = "NEW YORK CITY";
			bossName = "MEYER WOLF.";
			bossHP = 5;
            music = new music_level3();  // create an instance of the music
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
			addChild(currentScreen); // and attach it to the stage
		}

		override protected function getMap(mapIndex) {
		    switch(mapIndex) {
		        case 1:
		            return new level3_map1();
					break;
				case 2:
					return new level3_map2();
					break;
				case 3:
					return new level3_map3();
					break;
				case 4:
					stopMusic();
					bossMusic = new boss_music2();
					musicChannel = bossMusic.play(0, 100);
					return new level3_map4();
					break;
		    }
		    return false;
		}
				
	}//end class
}//end package