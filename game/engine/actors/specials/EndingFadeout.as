package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class EndingFadeout extends Animatable {
        
        public function EndingFadeout() {
            // i construct, therefore, i am.
            alwaysOn = true;
        }
        
        override public function setup() {
		    myName = "EndingFadeout"; // the generic name of our enemy
            mySkin = "EndingFadeoutSkin"; // the name of the skin for this enemy
            
            tile = 16; // select size
    		tilesWide = 16;
    		tilesTall = 15;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 3; // 5 replaced // how many frames should go by before we advance
		}
        
    }
    
}