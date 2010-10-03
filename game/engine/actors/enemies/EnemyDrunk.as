package engine.actors.enemies {
    
    import engine.actors.weapons.BottleWeapon;
    
    public class EnemyDrunk extends EnemyWalker {
        
        protected var stumbleDurationMax:Number = 50;
        protected var stumbleDurationMin:Number = 5;
        protected var stumbleDuration:Number = 8;
        protected var actionDuration:Number = 5;
        protected var actionCounter:Number = 0;
        protected var drinkDuration:Number = 50;
        protected const STUMBLING = 1;
        protected const DRINKING = 2;
        protected var currentStatus = STUMBLING;
        
        private var bottleWeapon:BottleWeapon;
		
		override public function setup() {
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
    		
    		myName = "EnemyDrunk"; // the generic name of our enemy
            mySkin = "DrunkSkin"; // the name of the skin for this enemy
            
            bottleWeapon = new BottleWeapon(this);
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
		}
		
		override public function moveMe() {
		    if(currentStatus == STUMBLING) {
		        if(actionCounter >= actionDuration) {
		            if(Math.ceil(Math.random() * 4) == 4) {
		                actionDuration = drinkDuration;
    		            currentStatus = DRINKING;
    		            setLoop(2, 0, 1, 0, 0);
    		            walkSpeed = 0;
    		        } else {
    		            currentStatus = STUMBLING;
    		            stumbleDuration = Math.ceil((Math.random() * stumbleDurationMax) + stumbleDurationMin);
    		            goingLeft = goingLeft == 0;
    		            if(Math.round(Math.random())) {
    		                walkSpeed = 1;
    		            } else {
    		                walkSpeed = -1;
    		            }
    		        }
    		        actionCounter = 0;
    		    }
		    } else if(currentStatus == DRINKING) {
		        if(actionCounter >= actionDuration) {
		            actionDuration = stumbleDuration;
		            actionCounter = 0;
		            if(Math.round(Math.random())) {
		                walkSpeed = 1;
		            } else {
		                walkSpeed = -1;
		            }
		            currentStatus = STUMBLING;
		            setLoop(0, 0, 1, 0, 0);
		            throwBottle();
		        }
		    }
		    this.x += walkSpeed;
		    actionCounter++;
		}
		
		private function throwBottle() {
		    myMap.spawnActor(bottleWeapon, this.x, this.y + 5);
		    bottleWeapon.throwBottle(goingLeft);
		}
        
        public function catchBottle(bottle) {
            trace("bottle caught!");
            myMap.removeFromMap(bottle);
        }
    }
    
}