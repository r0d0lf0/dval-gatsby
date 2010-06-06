package engine{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import managers.LevelManager;
	
	dynamic public class Level extends MovieClip {
	
		protected var mapList:Array = new Array();
		
 		public function Level():void{
			if(stage){
				buildLevel();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, initBuild);
			}
		}
		private function initBuild(evt:Event):void{
			buildLevel()
		}
		public function buildLevel():void{
			//called from override
		}
		
	}//end class
}//end package