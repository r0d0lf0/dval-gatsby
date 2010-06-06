package engine.levels{
	
	//import flash.display.MovieClip;
	import engine.Level;
	import engine.ILevel;
	import managers.MapManager;
	import managers.TimerManager;
	
	dynamic public class Level1 extends Level implements ILevel{
		
		public function Level1():void{
			
			this.mapList = new Array("LevelStart","level1_map1","level1_map2");
		}
		//This override is a bit slopy, but I don't have to
		//add ADDED_TO_STAGE eventListeners to everything this way.
		override public function buildLevel():void{
			trace(mapList[0]);
			//tell levelMangaer who we are
			MapManager.setLevel(this);
			//see if they were listening
			MapManager.loadMap(mapList[0]);
			TimerManager.wait(2,gotoLevel);
		}
		public function gotoLevel(evt:*){
			
			MapManager.loadMap(mapList[1]);
		}
		
	}//end class
}//end package