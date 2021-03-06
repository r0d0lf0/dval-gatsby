package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.actors.player.Hero;
    import engine.actors.enemies.Enemy;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
    
    public class LaserWeapon extends Weapon implements IObserver {
        
		private const laserSpeed:Number = 5;
        private var shootDistance:int = 100;
		private var loopSet = false;
		
        private var velx:Number = 0;
        private var vely:Number = 0;

		private var vecX:Number = 1;
		private var vecY:Number = 1;
        
        public function LaserWeapon(owner, vecx, vecy) {
			this.vecX = vecx; // normalized x vector
			this.vecY = vecy; // normalized y vector
            super(owner);
        }
        
		override public function setup() {
		    damage = 1;
		    
		    myName = "LaserWeapon";
            mySkin = "LaserWeaponSkin";

			tile = 8;
		    
		    tilesWide = 1;
    		tilesTall = 4;

		    collide_left = 4; // what pixel do we collide on on the left
    		collide_right = 12; // what pixel do we collide on on the right
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 1; // how many frames should go by before we advance (maybe this should be animationSpeed)

			//this.velx = laserSpeed * vecX;
			//this.vely = laserSpeed * vecY;
			this.velx = 0;
			this.vely = laserSpeed; 
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

		
		override public function update():void {
			if(!loopSet) {
				setLoop(0, 0, 1, 0, 0, 0);
				loopSet = true;
			}
		    if(frameCount >= shootDistance) {
		        frameCount = 0;
		        myMap.removeFromMap(this);
		    } else {
		        frameCount++;
		    }
		    this.x += velx;
			this.y += vely;
		    notifyObservers();
			animate();   
		}
		
    }
}