package engine.actors.specials {
    
    import engine.actors.Animatable;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class HealthPowerup extends Animatable {
        
        public var health = 1;
        private var taken = false;
        
        protected var scoreboard:Scoreboard = Scoreboard.getInstance();
        
        public function HealthPowerup() {
            // i construct, therefore, i am.
            trace("powerup!");
        }
        
        override public function setup() {
		    myName = "Money"; // the generic name of our enemy
            mySkin = "ItemMartiniSkin"; // the name of the skin for this enemy
            
            points = 100;
            
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
            speed = 10; // 5 replaced // how many frames should go by before we advance
            
            alwaysOn = true;
		}
        
        override public function notify(subject:*):void {
            if(!taken && subject is Hero) {
                if(checkCollision(subject)) {
                    subject.receivePowerup(this);
                    scoreboard.addToScore(this, points);
                    taken = true;
                    myMap.removeFromMap(this);
                }   
            }
        }
        
    }
    
}