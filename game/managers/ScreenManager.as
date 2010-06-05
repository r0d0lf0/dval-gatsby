package managers{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import Game;
	import engine.Engine
	import controls.KeyMap;

	dynamic public class ScreenManager {
		
		static private var screenList:Array = new Array('gameOpen','lvl1_map1','lvl1_map2','gameEnd');
		static public var currentScreen:String;
		static public var game:Game;
		
		//public function ScreenManager():void {
			// the constructor is unecessary in a static class
		//}
		
		// simple combo
		static public function setScreen(screen:String):void{
			clearScreen();
			for(var i in screenList){
				if(screenList[i] == screen){
					loadScreen(screen);
					trace(currentScreen);
				}
			}
		}
		// allows itteration
		static public function nextScreen():void{
			clearScreen();
			var place:int = 0;
			for(var i in screenList){
				if(screenList[i] == currentScreen){
					place = i;
				}
			}
			trace(currentScreen);
			ScreenManager.loadScreen(screenList[place+1]);
		}
		//load a new screen or level
		static public function loadScreen(screen:String):void{
			
			var ClassReference:Class = getDefinitionByName(screen) as Class;
			var peep = new ClassReference();
			currentScreen = screen;
        	game.addChild(peep);

		}
		//removes everything but the ScreenManager
		static public function clearScreen():void{
			for(var i:int=0;i<game.numChildren; i++){
				var gc:* = game.getChildAt(i);
				if(!(gc is Engine) && !(gc is KeyMap)){
					game.removeChild(game.getChildAt(i));
					trace('cleared');
				}
			}
		}
		// returns a list of screens,
		//a specific screen, or an empty array
		static public function getScreens(screen:int = -1):Array {
			var tempArr:Array = new Array();
			if (screen < 0){
				tempArr = screenList;
			}else if (int(screen)){
				tempArr = new Array(screenList[screen]);
			}
			return tempArr;
		}
		
		static public function setGame(g:Game):void{
			game = g;
		}
		
	}//end class
}//end package