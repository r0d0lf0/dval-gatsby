package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class ScorePowerup extends Animatable {
        
        public var points = 10;
        private var taken = false;
        
        public function ScorePowerup() {
            // i construct, therefore, i am.
            trace("powerup!");
        }
        
        override public function setup() {
		    
		    myName = "Money"; // the generic name of our enemy
            mySkin = "ItemMoneySkin"; // the name of the skin for this enemy
            
            tile = 16; // select size
    		tilesWide = 1;
    		tilesTall = 1;
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
		}
        
        override public function notify(subject:*):void {
            if(!taken && subject is Hero) {
                if(checkCollision(subject)) {
                    subject.receivePowerup(this);
                    taken = true;
                    myMap.removeFromMap(this);
                }   
            }
        }
        
    }
    
}