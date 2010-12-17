package engine.actors.enemies {
    
    import flash.events.Event;
    
    public class EnemyMaleDancer extends EnemyWalker {
        
        private var danceCount:int = 0;
		
		override public function setup() {
		    
		    myName = "EnemyMaleDancer"; // the generic name of our enemy
            mySkin = "MaleDancerSkin"; // the name of the skin for this enemy
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 2; // the final frame in the row
            nowFrame = 1; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 1; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
			deathFrame = 3;
		}
        
    }
    
}