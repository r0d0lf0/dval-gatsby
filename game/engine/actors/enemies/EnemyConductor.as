package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
    
    public class EnemyConductor extends EnemyWalker {
        
        private var myHero;
		
		override public function setup() {
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
    		
    		myName = "EnemyConductor"; // the generic name of our enemy
            mySkin = "ConductorSkin"; // the name of the skin for this enemy
            
            points = 150;
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 2; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance            
		}
        
        override protected function customUpdate() {
            if(myHero == null || myHero == false) {
                myHero = myMap.getHero();
            } else {
                if(myHero.stuckTo == this.stuckTo) {
                    if(velx > 0) {
                        velx = 6;
                    } else {
                        velx = -6;
                    }
                    loopRow = 0;
                    speed = 5;
                } else {
                    if(velx > 0) {
                        velx = 1;
                    } else {
                        velx = -1;
                    }
                    loopRow = 2;
                    speed = 10;
                }
            }
        }
        
    }
    
}