package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class SewerWater extends Animatable {
        
        public function SewerWater() {
            // i construct, therefore, i am.
        }
        
        override public function setup() {
		    myName = "SewerWater"; // the generic name of our enemy
            mySkin = "SewerWaterSkin"; // the name of the skin for this enemy
            
            tile = 16; // select size
    		tilesWide = 1;
    		tilesTall = 1;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 3; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
		}
        
    }
    
}