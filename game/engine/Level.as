package engine{
	
	import flash.display.MovieClip;
	import controls.KeyMap;
	import flash.events.Event;
	import engine.screens.*;
	import engine.ScoreboardDisplay;
	import engine.Scoreboard;
	
	dynamic public class Level extends MovieClip implements IScreen, ISubject, IObserver {
	
	    protected var levelNumber:String = "LEVEL X";
	    protected var levelName:String = "UNNAMED";
	
		protected var mapList:Array;
		protected var currentMapIndex:Number = 0;
		protected var currentScreen;
		protected var status:String = 'UNINITIALIZED';
		protected var scoreboardDisplay:ScoreboardDisplay;
		protected var scoreboard:Scoreboard;
		
	    private var observers:Array = new Array();
	    
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
	        setStatus('ACTIVE');
		}
		
		public function getStatus():String {
		    return status;
		}
		
		private function loadScreen(screen:MovieClip) {
		    myKeys.addSubscriber(screen);
		    this.addChild(screen);
		}
		
		public function setStatus(status:String):void {
		    this.status = status;
		}
		
		public function update():Boolean {
            return true; // this will get overwritten by the child class
		}
		
		public function restart():void {
		    
		}
		
		public function notify(subject:*):void {

		}
		
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		public function isObserver(observer):Boolean {
		    for(var ob:int=0; ob<observers.length; ob++) {
		        if(observers[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1);
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
		
	}//end class
}//end package