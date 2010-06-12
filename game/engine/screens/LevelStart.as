package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import engine.IScreen;
	import flash.text.TextField;
	
	public class LevelStart extends MovieClip implements IScreen {
	    
	    private var status:String = "UNINITIALIZED";
	    private var counter:Number = 0;
	    private var levelNumber = "UNDEFINED";
	    private var levelName = "UNDEFINED";
	    public function LevelStart() {
	        trace("GameOpen opened.");
	        status = 'ACTIVE';
	        level_number_display.text = levelNumber;
	        level_name_display.text = levelName;
	    }
	    
	    public function setLevelNumber(levelNumber:String) {
	        this.levelNumber = levelNumber;
	        level_number_display.text = levelNumber;
	    }
	    
	    public function setLevelName(levelName:String) {
	        this.levelName = levelName;
	        level_name_display.text = levelName;
	    }
	    
	    public function update():Boolean{
			//if spacebar
			counter++;
			if(counter > 120) {
			    status = 'COMPLETE';
			    return false;
			} else {
			    return true;
			}
			
		}
		
		public function getStatus():String {
		    return status;
		}
		
		public function restart():void {
		    
		}
	    
	}
}