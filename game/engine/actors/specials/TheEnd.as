package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import utils.FlipTimer;
    
    public class TheEnd extends Animatable {
        
        protected var totalFrameCounter = 0;
        protected var loopSet = false;
        
        protected var totalFramesDrawing = 43;
        protected var currentFrameDrawing = 0;
        protected var drawSpeed = 3;
        public var drawing = false;
        
        public function TheEnd() {
            // i construct, therefore, i am.
            trace("Cutscene2_Daisy!");
            
        }
        
        override public function setup() {
		    myName = "TheEnd"; // the generic name of our enemy
            mySkin = "TheEndSkin"; // the name of the skin for this enemy
            
            points = 0;
            
            tile = 16; // select size
    		tilesWide = 5;
    		tilesTall = 2;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 1; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 40; // how many frames should go by before we advance
            goingLeft = false;
            animate();
            this.alpha = 0;
            
            //setLoop(1, 0, 1, 0, 0, 30);
		}
		
		override public function update():void {
		    if(drawing) {
		        if(!loopSet) {
    		        setLoop(0, 0, 0, 0, 0, 10);
                    loopSet = true;
                    this.alpha = 1;
    		    } else {
    		        totalFrameCounter++;
    		        if(totalFrameCounter >= drawSpeed) {
    		            if(currentFrameDrawing < totalFramesDrawing) {
    		                totalFrameCounter = 0;
        		            currentFrameDrawing++;
        		            setLoop(currentFrameDrawing, 0, 0, 0, 0, 10);
    		            }
    		        }
    		        animate();
                }
		    }
        }
        
    }
    
}