package managers{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	dynamic public class ScreenManager extends MovieClip {
		
		private var screenList:Array = new Array('gameOpen','lvl1_map1','lvl1_map2','gameEnd');

		public function ScreenManager():void {
			//trace('Hello World!');
		}
		
		public function setScreen(screen:String):void{
			clearScreen();
			for(var i in screenList){
				if(screenList[i] == screen){
					loadScreen(screen);
					trace(screen);
				}
			}
		}
		public function loadScreen(screen:String):void{
			
			var ClassReference:Class = getDefinitionByName(screen) as Class;
			var peep = new ClassReference();
           this.addChild(peep);

		}
		public function clearScreen():void{
			for( var i in this){
				this.removeChild(this[i]);
			}
		}
		// returns a list of screens,
		//a specific screen, or an empty array
		public function getScreens(screen:int = -1):Array {
			var tempArr:Array = new Array();
			if (screen < 0){
				tempArr = screenList;
			}else if (int(screen)){
				tempArr = new Array(screenList[screen]);
			}
			trace(tempArr);
			return tempArr;
		}
		
	}//end class
}//end package