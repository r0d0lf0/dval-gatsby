package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import engine.Screen;
	
	public class GameOpen extends Screen {
	    
	    private var counter:Number = 0;
	    
	    public function GameOpen() {
	        trace("GameOpen opened.");
	        updateStatus(ACTIVE);
	    }
	    
	    override public function update(evt = null):Boolean{
			counter++;
			if(counter > 60) {
			    updateStatus(COMPLETE);
			    return false;
			} else {
			    return true;
			}
		}
	}
}