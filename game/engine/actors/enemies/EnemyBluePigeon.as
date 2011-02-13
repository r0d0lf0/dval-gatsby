package engine.actors.enemies {
    
    import flash.events.Event;
    
    public class EnemyBluePigeon extends EnemyFlyer {
		
	override public function setup() {
		    
	    myName = "EnemyBluePigeon"; // the generic name of our enemy
            mySkin = "BluePigeonSkin"; // the name of the skin for this enemy
		    
	    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 1; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance
            
            goingLeft = true;
            
            tilesWide = 1;
    	    tilesTall = 1;
	}
        
    }
    
}