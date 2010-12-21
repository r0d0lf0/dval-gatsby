package engine.actors.weapons{

    import engine.actors.Animatable;
    import engine.actors.Actor;
    import engine.actors.enemies.*;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    
	public class Projectile extends Animatable {
	    
        public var owner:Actor;
	    public var damage:Number = 1;
	    public var lifeSpan:Number = 2000;
	    public var isDead:Boolean = false;
	    protected var lifeTimer:Timer;
	    
        public var mySpeed = 1;
	    public var vecx = 1;
	    public var vecy = 1;
	    public var velx = 1;
	    public var vely = 1;
		
        public function Projectile(owner) {
            super();
            this.owner = owner;
        }
        
		override public function setup() {    
		    myName = "BaseballWeapon";
            mySkin = "BaseballWeaponSkin";
		    
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
		
		public function startLifeTimer() {
		    lifeTimer = new Timer(lifeSpan,1);
            lifeTimer.addEventListener(TimerEvent.TIMER, this.killMe);
			lifeTimer.start();
		}
        
        public function setOwner(owner) {
		    this.owner = owner;
		}
		
		public function killMe(e) {
		    trace("killing me");
		    HP = 0;
		    isDead = true;
		    lifeTimer.stop();
		    lifeTimer.removeEventListener(TimerEvent.TIMER, this.killMe);
		}
		
		override public function notify(subject):void {
		    if(subject is Enemy || subject is EnemyWalker) {
		        if(checkCollision(subject)) {
    	            subject.receiveDamage(this);
    	            frameCount = frameDelay;
                }
		    }
		}
		
		override public function update():void {
		    velx = mySpeed * vecx;
		    vely = mySpeed * vecy;
		    this.x += velx;
			this.y += vely;
		    notifyObservers();
			animate();
		}
		
	}//end class
}//end package