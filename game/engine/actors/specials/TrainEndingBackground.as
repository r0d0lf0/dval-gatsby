package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class TrainEndingBackground extends Animatable {
        
        public function TrainEndingBackground() {
            // i construct, therefore, i am.
            alwaysOn = true;
        }
        
        override public function setup() {
		    myName = "TrainEndingBackground"; // the generic name of our enemy
            mySkin = "TrainEndingSkin"; // the name of the skin for this enemy
            
            tile = 16; // select size
    		tilesWide = 16;
    		tilesTall = 13;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 30; // 5 replaced // how many frames should go by before we advance
		}
		
		override public function update():void {
	        animate();
            //totalFrameCounter++;
        }
        
    }
    
}