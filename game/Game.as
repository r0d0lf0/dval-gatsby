package{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import managers.ScreenManager;
	
	dynamic public class Game extends MovieClip {
	
		//public var scrnManager:ScreenManager = new ScreenManager();
	
		public function Game():void{
			
			if(stage){
				buildEnviron();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, initBuild);
			}
		}
		
		private function initBuild(evt:Event):void{
			buildEnviron()
		}
		private function buildEnviron():void{
			
			//addChild(scrnManager);
			//method check
			ScreenManager.getScreens();
			//this gets done only once, here.
			ScreenManager.setGame(this);
			//load game open
			ScreenManager.setScreen('gameOpen');
		}
		
	}//end class
}//end package