package engine.actors.weapons{

    import engine.actors.weapons.Projectile
    import engine.actors.player.Hero;
    
	public class TrashProjectile extends Projectile {
	            
	    public function TrashProjectile(owner) {
            super(owner);
        }        
	            
		override public function setup() {    
		    myName = "TrashProjectile";
            mySkin = "TrashSkin";
		    
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
            speed = 5; // how many frames should go by before we advance 
            
            startLifeTimer();
            animate();
		}
		
		override public function moveMe() {
		    // this will get overwritten later, if necessary
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
		    moveMe();
		    velx = mySpeed * vecx;
		    vely = mySpeed * vecy;
		    this.x += velx;
			this.y += vely;
		    notifyObservers();
			animate();
		}
		
	}//end class
}//end package