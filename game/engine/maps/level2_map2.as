package engine.maps {
    
    import engine.Map;
    import engine.actors.background.*;
    
    public class level2_map2 extends Map {
		
		override public function customUpdate():void {
		    // this will be replaced later
            // by children of this class, should they
            // require it
		}
		
		override public function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
		    heroHP = scoreboard.getHP();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
        
    }
    
}