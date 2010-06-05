package{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import managers.ScreenManager;
	import engine.Engine;
	import controls.KeyMap;
	
	dynamic public class Game extends MovieClip {
	
		//public var scrnManager:ScreenManager = new ScreenManager();
		private var engine:Engine = new Engine();
		private var keymap:KeyMap = new KeyMap();
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
			
			addChild(keymap);
			//method check
			ScreenManager.getScreens();
			//this gets done only once, here.
			ScreenManager.setGame(this);
			//load game open
			ScreenManager.setScreen('gameOpen');
			//
			engine.start();
		}
		
	}//end class
}//end package