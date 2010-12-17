package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import engine.Screen;
	import flash.text.TextField;
	
	import engine.Scoreboard;
	
	public class LevelStart extends Screen {
	    
	    private var counter:Number = 0;
	    private var levelNumber = "UNDEFINED";
	    private var levelName = "UNDEFINED";
	    
	    private var scoreboard = Scoreboard.getInstance();
	    
	    public function LevelStart() {
	        trace("GameOpen opened.");
	        updateStatus(ACTIVE);
	        level_number_display.text = levelNumber;
	        level_name_display.text = levelName;
	        lives_remaining_display.text = "x " + scoreboard.getLives();
	    }
	    
	    public function setLevelNumber(levelNumber:String) {
	        this.levelNumber = levelNumber;
	        level_number_display.text = levelNumber;
	    }
	    
	    public function setLevelName(levelName:String) {
	        this.levelName = levelName;
	        level_name_display.text = levelName;
	    }
	    
	    override public function update(evt = null):Boolean{
			counter++;
			if(counter > 120) {
			    updateStatus(COMPLETE);
			    return false;
			} else {
			    return true;
			}
			
		}
	    
	}
}
