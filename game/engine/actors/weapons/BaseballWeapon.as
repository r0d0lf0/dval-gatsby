package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.actors.player.Hero;
    import engine.actors.enemies.Enemy;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
    
    public class BaseballWeapon extends Weapon implements IObserver {
        
        private var throwDistance:int = 30;
        private var velX:Number = 0;
        private var velY:Number = 0;
        private const MAX_VEL_X = 5;
        
        public function BaseballWeapon(owner) {
            super(owner);
			goingLeft = owner.goingLeft;
        }
        
		override public function setup() {
		    flySpeed = 1.5;
		    damage = 1;
		    
		    myName = "BaseballWeapon";
            mySkin = "BaseballWeaponSkin";
		    
		    tilesWide = 1;
    		tilesTall = 1;
		    collide_left = 4; // what pixel do we collide on on the left
    		collide_right = 12; // what pixel do we collide on on the right
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 3; // how many frames should go by before we advance
    		if(goingLeft) {
    		    velX = -flySpeed;
    		} else {
    		    velX = flySpeed;
    		}
			animate();
		}
		
		override public function notify(subject):void {
		    if(subject is Hero) {
		        if(checkCollision(subject)) {
    	            subject.receiveDamage(this);
    	            frameCount = frameDelay;
                }
		    }
		}
		
		public function fireBullet(goingLeft) {
		    frameCount = 0;
		    frameDelay = throwDistance;
		}
		
		override public function update():void {
		    if(frameCount >= throwDistance) {
		        frameCount = 0;
		        myMap.removeFromMap(this);
		    } else {
		        frameCount++;
		    }
		    if(velX > MAX_VEL_X) {
		        velX = MAX_VEL_X;
		    }
		    this.x += velX;
		    notifyObservers();
			animate();   
		}
		
    }
}