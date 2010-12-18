package engine.actors.background {
    
    import engine.actors.Animatable;
    import engine.Map;
    import engine.IObserver;
    import engine.actors.player.Hero;
    
    public class Level2Trees extends Animatable implements IObserver {
        
        private var playerOffset = 0;
        private var scrollSpeed = 3;
        private var loopPoint = 400;
        public var followHero = true;
        
        override public function setup() {
            
		    myName = "Level2Sky"; // the generic name of our enemy
            mySkin = "TreesAnimatedSkin"; // the name of the skin for this enemy
            
            tile = 16; // select size
    		tilesWide = 50;
    		tilesTall = 3;
    		
    		alwaysOn = true;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance
            
            animate();
		}
        
        override public function notify(subject:*):void {
            if(subject is Hero) {
                playerOffset += scrollSpeed;
                if(playerOffset > loopPoint) {
                    playerOffset = playerOffset - loopPoint;
                }
                if(followHero) {
                    if(subject.x > 128) {
                        this.x = subject.x - 128;
                    } else {
                        this.x = 0;
                    }
                    this.x -= playerOffset;
                } else {
                    this.x = -playerOffset;
                }
                
            } if(subject is Map) {
                trace("Map!");
            }
        }
        
        override public function update():void {
            animate();
        }
        
    }
    
}