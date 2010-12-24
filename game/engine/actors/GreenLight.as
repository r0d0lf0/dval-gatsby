package engine.actors {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    
    public class GreenLight extends Animatable {
        
        protected var totalFrameCounter = 0;
        protected var loopSet = false;
        
        public function GreenLight() {
            // i construct, therefore, i am.
            trace("Cutscene2_Daisy!");
            
        }
        
        override public function setup() {
		    myName = "GreenLight"; // the generic name of our enemy
            mySkin = "GreenLightSkin"; // the name of the skin for this enemy
            
            points = 0;
            
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
            speed = 20; // how many frames should go by before we advance
            goingLeft = false;
		}
		
		override public function update():void {
		        animate();
                totalFrameCounter++;
        }
        
    }
    
}