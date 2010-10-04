package engine{
	
	import flash.display.MovieClip;
	import controls.KeyMap;
	import flash.events.*;
	import flash.events.Event;
	import engine.screens.*;
	import engine.Screen;
	import engine.ScoreboardDisplay;
	import engine.Scoreboard;
	
	dynamic public class Level extends Screen {
	
	    protected var levelNumber:String = "LEVEL X";
	    protected var levelName:String = "UNNAMED";
	
		protected var mapList:Array;
		protected var currentMapIndex:Number = 0;
		protected var currentScreen;
		
		protected var scoreboardDisplay:ScoreboardDisplay;
		protected var scoreboard:Scoreboard;
	    
	    protected var myKeys:KeyMap = KeyMap.getInstance();
		
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
		    scoreboardDisplay = new ScoreboardDisplay();
		    scoreboard = Scoreboard.getInstance();
	        scoreboard.addObserver(scoreboardDisplay);
	        scoreboard.setHP(3);
	        updateStatus(ACTIVE);
		}
		
		private function loadScreen(screen:MovieClip) {
		    myKeys.addSubscriber(screen);
		    this.addChild(screen);
		}
			
	}//end class
}//end package