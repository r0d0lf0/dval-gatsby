package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.actors.enemies.Enemy;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
    
    public class HatWeapon extends Animatable {
        
        private var flySpeed:Number = 7;
        private var owner:Actor;
        private var returning:Boolean = false;
        private var throwDistance:int = 15;
        
        private var inertia:Number = 4; // amount of inertia to change velocity
        private var velX:Number = 0;
        private var velY:Number = 0;
        
        private var frameCount:int = 0;
        private var frameDelay:int = 2;
        
        public function HatWeapon(owner) {
            this.owner = owner;
		}
		
		override public function setup() {
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
		
		public function setOwner(owner) {
		    this.owner = owner;
		}
				
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
		        if(subject is Enemy) {
		            trace("Hit!");
		            subject.receiveDamage(1);
		            returning = true;
		        } else if(subject is Hero && returning) {
		            subject.catchMe(this);
		        }
            }
		}
		
		public function throwHat(goingLeft) {
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
		
		public function collide(subject) {
		    
		}
		
		override public function update():void {
		    animate();
		    
		    if(frameCount >= frameDelay) {
		        frameCount = 0;
		        if(!returning) {
		            returning = true;
		            frameDelay = 2;
    		    } else {
    		        flyBack();
    		    }
    		    
		        
		    } else {
		        frameCount++;
		    }
		    this.x += velX;
		    this.y += velY
		    
		    notifyObservers();
		    
		}
        
    }
    
}