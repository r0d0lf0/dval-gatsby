package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
    import flash.media.Sound;
	import flash.media.SoundChannel;
	
    public class EnemyAlligator extends Enemy {
	
		protected var jumping:Boolean = false;
		protected const jumpSpeed = -14;
		protected var vely = 0;
		protected var gravity:Number = .25;  //how much the velocity changes on each frameEvent
		
		protected const jumpDelay = 60;
		protected var actionCounter = 0;
		protected var splash_sound;
		protected var effectsChannel;
		protected var soundPlayed = false;

		override public function setup() {
			myName = "EnemyAlligator"; // the generic name of our enemy
	        mySkin = "AlligatorSkin"; // the name of the skin for this enemy

            points = 100;

			damage = 1;
		    startFrame = 0; // the first frame to loop on
	        endFrame = 1; // the final frame in the row
	        nowFrame = 1; // current frame in row
	        loopFrame = 0; // frame at which to loop
	        loopType = 0; // 0 loops, 1 bounces
	        loopRow = 0; // which row are we on
	        loopDir = 1; // loop forward (to the right) by default
	        speed = 10; // 5 replaced // how many frames should go by before we advance
	        
	        deathFrame = 2;

	        goingLeft = false;

	        tilesWide = 1;
		    tilesTall = 3;
			this.y = 240; // put us just below the water line
			splash_sound = new sewer_splash_sound();
		}
		
		private function applyPhysics() {
			vely += gravity;
			if(vely > 14) {
				vely = 14;
			}
		}
		
		private function jump() {
		    if(HP) {
		        this.vely = jumpSpeed;
    			jumping = true;
		    }
		}
		
		override public function update():void {
			animate();
			if(jumping) { // if we're jumping
			    if(!soundPlayed) {
			        effectsChannel = splash_sound.play(0);
			        soundPlayed = true;
			    }
			    
				applyPhysics(); // apply physics
				this.y += vely / 2; // and move us
				if(this.y > 240) { // if we're below the screen
					vely = 0; // then stop us from falling
					this.y = 240; // position us just off screen
					jumping = false; // and reset the jumping flag
				}
			} else { // if we're not jumping
				actionCounter++; // increment our frame counter
				if(actionCounter >= jumpDelay) { // if we've waiting long enough
				    soundPlayed = false;
					jump(); // then jump
					actionCounter = 0; // and reset our frameCounter
				}
			}
			if(!deadFlag) {
			    checkDeath();
			    if(deadFlag) {
			        if(this.vely < 0) {
			            this.vely = 0;
			        }
			    }
			}
			notifyObservers();
		}
	
    }
    
    
}