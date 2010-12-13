package engine.actors {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    
    public class Explosion extends Animatable {
        
        protected var totalFrameCounter = 0;
        protected var frameKill = 15;
        
        public function Explosion() {
            // i construct, therefore, i am.
            trace("Explosion!");
        }
        
        override public function setup() {
		    myName = "Explosion"; // the generic name of our enemy
            mySkin = "ExplosionSkin"; // the name of the skin for this enemy
            
            points = 0;
            
            tile = 16; // select size
    		tilesWide = 2;
    		tilesTall = 2;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 3; // how many frames should go by before we advance
            
            goingLeft = false;
		}
		
		override public function update():void {
            animate();
            totalFrameCounter++;
            if(totalFrameCounter >= frameKill) {
                myMap.removeFromMap(this);
            }
        }
        
    }
    
}