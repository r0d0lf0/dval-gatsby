package engine.actors.weapons {
    
    import engine.actors.weapons.Projectile;
    
    public class HatProjectile extends Projectile {
        
        public function HatProjectile(owner) {
            super(owner);
        }
        
        override public function setup() {    
		    myName = "HatProjectile";
            mySkin = "HatWeaponSkin";
            
            mySpeed = 2;
		    
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
            
            startLifeTimer();
            animate();
		}
        
    }
    
}