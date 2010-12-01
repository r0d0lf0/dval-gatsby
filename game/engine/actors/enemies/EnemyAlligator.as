package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
    
    public class EnemyAlligator extends Enemy {
	
		protected var jumping:Boolean = false;
		protected const jumpSpeed = -13;
		protected var vely = 0;
		protected var gravity:Number = .4;  //how much the velocity changes on each frameEvent
		
		protected const jumpDelay = 60;
		protected var actionCounter = 0;

		override public function setup() {
			myName = "EnemyAlligator"; // the generic name of our enemy
	        mySkin = "AlligatorSkin"; // the name of the skin for this enemy

			damage = 1;
		    startFrame = 0; // the first frame to loop on
	        endFrame = 1; // the final frame in the row
	        nowFrame = 1; // current frame in row
	        loopFrame = 0; // frame at which to loop
	        loopType = 0; // 0 loops, 1 bounces
	        loopRow = 0; // which row are we on
	        loopDir = 1; // loop forward (to the right) by default
	        speed = 5; // how many frames should go by before we advance

	        goingLeft = false;

	        tilesWide = 1;
		    tilesTall = 3;
			this.y = 240; // put us just below the water line
		}
		
		override public function notify(subject:*):void {
			if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
				if(subject is Hero) {
					subject.receiveDamage(this);
				}
		    }
		}
		
		private function applyPhysics() {
			vely += gravity;
			if(vely > 14) {
				vely = 14;
			}
		}
		
		private function jump() {
			this.vely = jumpSpeed;
			jumping = true;
		}
		
		override public function update():void {
			animate();
			if(jumping) { // if we're jumping
				applyPhysics(); // apply physics
				this.y += vely; // and move us
				if(this.y > 240) { // if we're below the screen
					vely = 0; // then stop us from falling
					this.y = 240; // position us just off screen
					jumping = false; // and reset the jumping flag
				}
			} else { // if we're not jumping
				actionCounter++; // increment our frame counter
				if(actionCounter >= jumpDelay) { // if we've waiting long enough
					jump(); // then jump
					actionCounter = 0; // and reset our frameCounter
				}
			}
		}
	
    }
    
    
}