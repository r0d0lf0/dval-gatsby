package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.actors.player.Hero;
    import engine.actors.enemies.Enemy;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
    
    public class BottleWeapon extends Weapon implements IObserver {
        
        private var throwDistance:int = 60;
        private var throwHeight = -19;
        private var velX:Number = 0;
        private var velY:Number = 0;
        private var gravity = 1;
        private const MAX_VEL_Y = 8;
        private const MAX_VEL_X = 5;
        
        public function BottleWeapon(owner) {
            super(owner);
        }
        
		override public function setup() {
		    flySpeed = 2;
		    velY = throwHeight;
		    damage = 1;
		    
		    myName = "BottleWeapon";
            mySkin = "BottleWeaponSkin";
		    
		    tilesWide = 1;
    		tilesTall = 1;
		    collide_left = 2; // what pixel do we collide on on the left
    		collide_right = 14; // what pixel do we collide on on the right
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 7; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 2; // how many frames should go by before we advance
    		
		}
		
		override public function notify(subject):void {
		    if(subject is Hero) {
		        if(checkCollision(subject)) {
    	            subject.receiveDamage(this);
    	            frameCount = frameDelay;
                }
		    }
		}
		
		public function throwBottle(goingLeft) {
		    this.velY = throwHeight;
		    frameCount = 0;
		    frameDelay = throwDistance;
		    if(goingLeft) {
    		    velX = -flySpeed;
    		} else {
    		    velX = flySpeed;
    		}
		}
		
		public function applyPhysics():void {
		    // velocitize y (gravity)
			if (this.velY < MAX_VEL_Y) {
			    this.velY += this.gravity;
            }
			
			// check map bounds
			if(this.x < 0) {
			    this.x = 0;
			}
		}
		
		override public function update():void {
		    animate();		    
		    if(frameCount >= frameDelay) {
		        frameCount = 0;
		        owner.catchBottle(this);
		    } else {
		        frameCount++;
		    }
		    applyPhysics();
		    if(velX > MAX_VEL_X) {
		        velX = MAX_VEL_X;
		    }
		    if(velY > MAX_VEL_Y) {
		        velY = MAX_VEL_Y;
		    }
	        this.y += velY / 2; // update our y variable
			this.x += velX / 2; // update our x variable
			
			if(velX > 0) {
			    this.x = Math.ceil(this.x);
			} else {
			    this.x = Math.floor(this.x);
			}
			
			if(velY > 0) {
			    this.y = Math.ceil(this.y);
			} else {
			    this.y = Math.floor(this.y);
			}
		    notifyObservers();
		}
		
    }
}