package engine.actors.weapons {
    
    import engine.IObserver;
    import engine.actors.Actor;
	import engine.Scoreboard;
    import engine.actors.player.Hero;
    import engine.actors.enemies.*;
    import engine.actors.geoms.*;
    import flash.events.Event;
    import engine.actors.Animatable;
	import flash.geom.Point;
    
    public class HatWeapon extends Weapon implements IObserver {
        
        private var returning:Boolean = false;
        private var throwDistance:int = 15;
        
        private var inertia:Number = 1.5; // amount of inertia to change velocity
        public var velx:Number = 0;
        public var vely:Number = 0;
		private var scoreboard:Scoreboard = Scoreboard.getInstance();

		private var successiveHits = 0;
        
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
            speed = 5; // how many frames should go by before we advance
    		
		}
				
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
		        if(subject is Enemy || subject is EnemyWalker) {
					if(subject.getHP() > 0) {
						successiveHits++;
						scoreboard.setMultiplier(successiveHits);
						subject.receiveDamage(this);
						myMap.removeFromMap(this);
					}
		        }
            }
		}
		
		override public function update():void {
		    animate();
		    
		    if(frameCount >= frameDelay) {
		        frameCount = 0;
		        if(!returning) {
		            myMap.removeFromMap(this);
    		    } else {
    		        myMap.removeFromMap(this);
    		    }
    		    frameDelay = 2;
		    } else {
		        frameCount++;
		    }
		    
		    this.y += vely / 2; // update our y variable
            this.x += velx / 2; // update our x variable
			/*
			if(velx > 0) {
			    this.x = Math.ceil(this.x);
			} else {
			    this.x = Math.floor(this.x);
			}
			
			if(vely > 0) {
			    this.y = Math.ceil(this.y);
			} else {
			    this.y = Math.floor(this.y);
			}
		    */
		    notifyObservers();
		    
		}
        
    }
    
}