package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import engine.IScreen;
	
	public class LevelStart extends MovieClip implements IScreen {
	    
	    private var status:String = "UNINITIALIZED";
	    private var counter:Number = 0;
	    
	    public function LevelStart() {
	        trace("GameOpen opened.");
	        status = 'ACTIVE';
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