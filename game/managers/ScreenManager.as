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
				    case 'GameOpen':
				        return new GameOpen();
				        break;
				    case 'GameOver':
				        return new GameOver();
				        break;
				    case 'Level1':
				        return new Level1();
				        break;
				    case 'Level2':
				        return new Level2();
				        break;
				    case 'Level3':
				        return new Level3();
				        break;
					case 'Level4':
						return new Level4();
						break;
					case 'CutScene1':
						return new CutScene1();
						break;
					case 'CutScene2':
					    return new CutScene2();
					    break;
					case 'CutScene3':
					    return new CutScene3();
					    break;
					case 'GameEnding':
					    return new GameEnding();
					    break;
					case 'TrainEnding':
					    return new TrainEnding();
					    break;
					case 'GraveyardEnding':
					    return new GraveyardEnding();
					    break;
				}
				return false;
		}
		
	}//end class
}//end package