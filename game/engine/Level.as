package engine{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import engine.screens.*;
	import engine.ScoreboardDisplay;
	import engine.Scoreboard;
	
	dynamic public class Level extends MovieClip implements IScreen {
	
	    protected var levelNumber:String = "LEVEL X";
	    protected var levelName:String = "UNNAMED";
	
		protected var mapList:Array;
		protected var currentMapIndex:Number = 0;
		protected var currentScreen;
		protected var status:String = 'UNINITIALIZED';
		protected var scoreboardDisplay:ScoreboardDisplay;
		protected var scoreboard:Scoreboard;
		
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
	        setStatus('ACTIVE');
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