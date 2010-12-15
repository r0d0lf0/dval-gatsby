package{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import managers.ScreenManager;
	import engine.Engine;
	import controls.KeyMap;
	
	dynamic public class Game extends MovieClip {
	
		//public var scrnManager:ScreenManager = new ScreenManager();
		private var engine:Engine;
		private var keymap:KeyMap = KeyMap.getInstance();
		public function Game():void{
			
			if(stage){
				buildEnviron();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, initBuild);
			}
		}
		
		private function initBuild(evt:Event):void{
			buildEnviron();
		}
		private function buildEnviron():void{
			engine = new Engine();  // create an engine, it will start automatically when it's added to stage
			addChild(keymap);
			addChild(engine);
		}
		
	}//end class
}//end package