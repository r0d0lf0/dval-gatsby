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
	    
		public function Level2():void{
		    mapList = new Array('level2_map1', 'level2_map2'); // use this later for dylan-style level loading by converting strings to classes
			levelNumber = "LEVEL 2";
			stageNumber = 2;
			levelName = "TRAIN TO THE CITY";
			bossName = "TJ ECKLEBERG";
			bossHP = 5;
			music = new music_level2();
			currentScreen = new LevelStart(); // we're just starting, so create a LevelStart screen
			currentScreen.setLevelName(levelName);  // give it our level name
			currentScreen.setLevelNumber(levelNumber); // and our level number
		}

		override protected function getMap(mapIndex) {
		    switch(mapIndex) {
		        case 1:
		            return new level2_map1();
		        case 2:
		            stopMusic();
				    bossMusic = new boss_music2();
				    musicChannel = bossMusic.play(0, 100);
		            return new level2_map2();
		    }
		    return false;
		}
				
	}//end class
}//end package