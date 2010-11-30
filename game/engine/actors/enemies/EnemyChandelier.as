package engine.actors.enemies {
    
    import engine.actors.enemies.Enemy;
	import engine.actors.player.Hero;
	import flash.media.Sound;
	import flash.media.SoundChannel;
    
    public class EnemyChandelier extends Enemy {
	
		protected var falling = false;
		protected const fallSpeed = 3;
		protected const triggerDistance = 25;
		protected var vely = 0;
		
		private var chandelierSound = new chandelier_sound();

		override public function setup() {
			myName = "EnemyChandelier"; // the generic name of our enemy
	        mySkin = "ChandelierSkin"; // the name of the skin for this enemy

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

	        tilesWide = 3;
		    tilesTall = 3;	
		}
		
		override public function notify(subject:*):void {
			if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
				if(subject is Hero) {
					subject.receiveDamage(this);
				}
		    }
		
			if(subject is Hero) {
				if((Math.abs(subject.x - this.x) < triggerDistance) && !falling) {
					falling = true;
					vely = fallSpeed;
					var soundChannel = chandelierSound.play(0);
				}
			}
		}
		
		override public function update():void {
			this.y += vely;
		}
	
    }
    
    
}