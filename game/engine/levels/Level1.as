package engine.levels{
	
	//import flash.display.MovieClip;
	import engine.Level;
	import engine.ILevel;
	import managers.LevelManager;
	
	dynamic public class Level1 extends Level implements ILevel{
		
		public function Level1():void{
			
			this.mapList = new Array("LevelStart","lvl1_map1","lvl1_map2");
		}
		//This override is a bit slopy, but I don't have to
		//add ADDED_TO_STAGE eventListeners to everything this way.
		override public function buildLevel():void{
			trace(mapList[0]);
			//tell levelMangaer who we are
			LevelManager.setLevel(this);
			//see if they were listening
			LevelManager.loadMap(mapList[0]);
		}
		
	}//end class
}//end package