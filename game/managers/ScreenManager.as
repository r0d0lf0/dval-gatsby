package managers{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import Game;
	import engine.Engine
	import controls.KeyMap;
	import engine.screens.*;
	import engine.levels.*;

	dynamic public class ScreenManager {
		
		static private var screenList:Array = new Array('gameOpen','Level1','lvl1_map2','gameEnd');
		static public var currentScreen:String;
		static public var game:Game;
		
		//public function ScreenManager():void {
			// the constructor is unecessary in a static class
		//}
		
		//load a new screen or level
		public function getScreen(screen:String) {
			
			/*trace('search: '+screen.toString().search('Level'));
			if(screen.toString().search('Level')>-1){
				//load level
				trace(String('engine.levels.'+screen));
				var ClassReference:Class = getDefinitionByName(String('engine.levels.'+screen)) as Class;
				var peep = new ClassReference();
				currentScreen = screen;
				return peep;
			}else{
				var ClassReference:Class = getDefinitionByName(screen) as Class;
				var peep = new ClassReference();
				currentScreen = screen;
				return peep;
			}*/
			
			if(screen == 'gameOpen') {
			    return new gameOpen();
			} else if(screen == 'Level1') {
			    return new Level1();
			}

		}
		
	}//end class
}//end package