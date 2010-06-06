﻿package managers{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import Game;
	import engine.Engine
	import controls.KeyMap;
	import engine.screens.*;
	import engine.levels.*;

	dynamic public class ScreenManager {
		
		static public var game:Game;
		
		//public function ScreenManager():void {
			// the constructor is unecessary in a static class
		//}
		
		//load a new screen or level
		public function getScreen(screen:String) {
				/*var ClassReference:Class = getDefinitionByName(screen) as Class;
				var newScreen = new ClassReference();
				return newScreen;*/
				switch(screen) {
				    case 'gameOpen':
				        return new gameOpen();
				    case 'Level1':
				        return new Level1();
				}
				return false;
		}
		
	}//end class
}//end package