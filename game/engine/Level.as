package engine{
	
	import flash.display.MovieClip;
	import flash.events.Event;
<<<<<<< local
	import engine.screens.*;
=======
	import managers.MapManager;
>>>>>>> other
	
	dynamic public class Level extends MovieClip implements IScreen {
	
		protected var mapList:Array;
		protected var currentMapIndex:Number = 0;
		protected var currentScreen;
		protected var status:String = 'UNINITIALIZED';
		//protected var startScreen = new LevelStart();
		// add in stuff for level start screen later
		
 		public function Level():void{
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
		public function buildLevel():void{
	        
		}
		
		public function getStatus():String {
		    return status;
		}
		
		public function setStatus(status:String):void {
		    this.status = status;
		}
		
		public function update():Boolean {
            return true; // this will get overwritten by the child class
		}
		
		public function restart():void {
		    
		}
		
		
	}//end class
}//end package