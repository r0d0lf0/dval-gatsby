package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import utils.FlipTimer;
    
    public class NickTrain extends Animatable {
        
        protected var totalFrameCounter = 0;
        protected var loopSet = false;
        
        protected var xPos = 0;
        protected var yPos = 0;
        
        protected var xVel = 0;
        protected var yVel = 0;
        
        protected var walkingFlip = false;
        
        public function NickTrain() {
            // i construct, therefore, i am.
            trace("Cutscene2_Daisy!");
            
        }
        
        override public function setup() {
		    myName = "NickTrain"; // the generic name of our enemy
            mySkin = "NickTrainSkin"; // the name of the skin for this enemy
            
            points = 0;
            
            tile = 16; // select size
    		tilesWide = 2;
    		tilesTall = 2;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 1; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 40; // how many frames should go by before we advance
            goingLeft = false;
            animate();
            
            //setLoop(1, 0, 1, 0, 0, 30);
		}
		
		override public function update():void {
		    if(!loopSet) {
		        setLoop(1, 0, 1, 0, 0, 30);
		        xPos = this.x;
		        yPos = this.y;
                loopSet = true;
		    } else {
		        animate();
                totalFrameCounter++;
                if(totalFrameCounter == 120) {
                    yVel = .4;
                    setLoop(2, 0, 1, 0, 0, 20);
                }
                if(this.yPos >= 120 && !walkingFlip) {
                    yVel = 0;
                    yPos = 120;
                    setLoop(1, 0, 1, 0, 0, 60);
                    new FlipTimer(this, "startWalking", 3000);
                    walkingFlip = true;
                }
		    }
		    calculateMovement();
        }
        
        public function startWalking() {
            setLoop(0, 0, 3, 0, 0, 10);
            xVel = .75;
        }
        
        private function calculateMovement() {
            xPos += xVel;
            yPos += yVel;
            this.x = Math.floor(xPos);
            this.y = Math.floor(yPos);
        }
        
    }
    
}