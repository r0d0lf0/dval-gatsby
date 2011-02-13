package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
	import engine.actors.weapons.HatProjectile;
	import flash.media.Sound;
	import flash.media.SoundChannel;
    
    public class EnemyChandelier extends Enemy {
	
		protected var falling = false;
		protected const fallSpeed = 2;
		protected const triggerDistance = 60;
		protected var vely = 0;
		
		private var chandelierSound = new chandelier_sound();

		override public function setup() {
			myName = "EnemyChandelier"; // the generic name of our enemy
	        mySkin = "ChandelierSkin"; // the name of the skin for this enemy
	        
	        collide_left = 14; // what pixel do we collide on on the left
    		collide_right = 45; // what pixel do we collide on on the right
	        
	        points = 250;

			damage = 1;
		    startFrame = 0; // the first frame to loop on
	        endFrame = 2; // the final frame in the row
	        nowFrame = 0; // current frame in row
	        loopFrame = 0; // frame at which to loop
	        loopType = 0; // 0 loops, 1 bounces
	        loopRow = 0; // which row are we on
	        loopDir = 1; // loop forward (to the right) by default
	        speed = 10; // 5 replaced // how many frames should go by before we advance

	        goingLeft = false;
	        deadFlag = false;

	        tilesWide = 3;
		    tilesTall = 3;	
		}
		
		override public function collide(observer, ...args) {
            if(observer is Hero && !deadFlag) {
		        observer.receiveDamage(this); // otherwise, if we've hit the hero, make him regret it
		    }
		}
		
		override public function notify(subject:*):void {
			if(subject is Hero) {
				if((Math.abs(subject.x - this.x) < triggerDistance) && !falling) {
					falling = true;
					vely = fallSpeed;
					var soundChannel = chandelierSound.play(0);
				}
			}
			if(subject is HatProjectile) { // if it's the hero's weapon
			    if(checkCollision(subject)) {
    	            hitDirection = subject.goingLeft; // and determine the direction from whence you were hit
			    }
	        }
		}
		
		override public function update():void {
			this.y += vely;
			if(!deadFlag) {
			    notifyObservers();
			    checkDeath();
			}
			animate();
		}
	
    }
    
    
}