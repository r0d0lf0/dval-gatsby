package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.actors.enemies.*;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
    
    public class HatWeapon extends Weapon implements IObserver {
        
        private var returning:Boolean = false;
        private var throwDistance:int = 15;
        
        private var inertia:Number = 4; // amount of inertia to change velocity
        private var velX:Number = 0;
        private var velY:Number = 0;
        
        public function HatWeapon(owner) {
            super(owner);
        }
		
		override public function setup() {
		    
		    damage = 1;
		    
		    myName = "HatWeapon";
            mySkin = "HatWeaponSkin";
		    
		    tilesWide = 1;
    		tilesTall = 1;
		    collide_left = 2; // what pixel do we collide on on the left
    		collide_right = 14; // what pixel do we collide on on the right
    		
    		startFrame = 0; // the first frame to loop on
            endFrame = 3; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 1; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 2; // how many frames should go by before we advance
    		
		}
				
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
		        if(subject is Enemy || subject is EnemyWalker) {
		            subject.receiveDamage(this);
		            if(!returning) {
		                returning = true;
		                velX = -velX;
		            }
		        } else if(subject is Hero && returning) {
		            subject.catchMe(this);
		        }
            }
		}
		
		public function throwHat(goingLeft) {
		    frameCount = 0;
		    frameDelay = throwDistance;
		    if(goingLeft) {
    		    velX = -flySpeed;
    		} else {
    		    velX = flySpeed;
    		}
            velY = 0;
    		returning = false;
		}
		
		private function flyBack() {
		    if(owner.x >= this.x) {
		        velX += inertia;
		    } else {
		        velX -= inertia;
		    }

		    if(velX >= flySpeed) {
		       velX = flySpeed; 
		    } else if(velX <= -flySpeed) {
		       velX = -flySpeed;
		    }
		    
		    if(owner.y >= this.y) {
		        velY += inertia;
		    } else {
		        velY -= inertia;
		    }

		    if(velY >= flySpeed) {
		       velY = flySpeed; 
		    } else if(velY <= -flySpeed) {
		       velY = -flySpeed;
		    }
		}
		
		override public function update():void {
		    animate();
		    
		    if(frameCount >= frameDelay) {
		        frameCount = 0;
		        if(!returning) {
		            returning = true;
    		    } else {
    		        flyBack();
    		    }
    		    frameDelay = 2;
		    } else {
		        frameCount++;
		    }
		    this.x += velX;
		    this.y += velY
		    
		    notifyObservers();
		    
		}
        
    }
    
}