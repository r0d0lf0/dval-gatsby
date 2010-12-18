package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
    
    public class EnemyHobo extends EnemyWalker {
        
		override public function setup() {
			points = 500;
			
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
    		
    		myName = "EnemyHobo"; // the generic name of our enemy
            mySkin = "HoboSkin"; // the name of the skin for this enemy
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance

			goingLeft = true;
			velx *= -1;
			frameDelay = 0;
		}
		
		
		override public function update():void {
            if(HP) {
                if(stuckTo) {
                    depart(stuckTo);
                    this.y += -gravity;
                    vely = -jumpVelocity;
                    setLoop(0, 1, 0, 0, 0, 2);
                }
                moveMe();
                checkDeath();
    		    if(deadFlag) {
    		       if(this.y > 240) {
                       myMap.removeFromMap(this);
    		       } else {
    		           setLoop(0, 2, 2, 2, 0);
        		       this.y += 2;
    		       }
                }
            } else {
                killMe();
            }
		}
        
    }
    
}