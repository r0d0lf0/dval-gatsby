package engine.actors.enemies {
    
    import engine.actors.enemies.EnemyWalker;
    import engine.ISubject;
    import engine.IObserver;
    import engine.actors.geoms.*;
    import engine.actors.Explosion;
    
    public class EnemyBossWolfsheim extends EnemyWalker {
	
	protected var actionDelay = 60;
	protected var actionCounter = 0;
	protected const JUMPING = 1;
	protected const POINTING = 2;
	protected var currentAction = JUMPING;
	protected var explodeStarted = false;
	protected var explodedYet = false;
	protected var explosionCounter = 0;
	
	override public function setup() {
	    collide_left = 10; // what pixel do we collide on on the left
    	    collide_right = 22; // what pixel do we collide on on the right

	    walkSpeed = 0;
	    velx = walkSpeed;
	    HP = 1000;
	    
	    points = 2500;
    	    
    	    myName = "EnemyBossWolfsheim"; // the generic name of our enemy
            mySkin = "WolfsheimSkin"; // the name of the skin for this enemy
    	    
    	    startFrame = 0; // the first frame to loop on
            endFrame = 1; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 0; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 10; // 5 replaced // how many frames should go by before we advance            
	}
	
	override public function killMe():void {
	    HP = 0;
	    if(myStatus != 'DYING') {
		setLoop(2, 0, 1, 0, 0, 2); // make us die
	        myStatus = 'DYING';
	        gravity = 0;
	        this.vely = -1;
		scoreboard.addToScore(this, points);
	        if(hitDirection == 'LEFT') {
	            this.velx = 3;
	        } else if(hitDirection == 'RIGHT')  {
	            this.velx = -3;
	        }
	    }
	    if(frameCount >= frameDelay) {
		//applyPhysics();
		if(!explodeStarted) {
		    this.y += vely;
    		    if(this.y < 50) {
    		        explodeStarted = true;
    		    }
    		} else if(!explodedYet) {
    		    actionDelay = 20;
    		    actionCounter++;
    		    if(actionCounter >= actionDelay) {
    		        var myExplosion = new Explosion();
    		        actionCounter = 0;
    		        explosionCounter++;
    		        myMap.spawnActor(myExplosion, (Math.floor(Math.random() * this.width) + this.x - 16), (Math.floor(Math.random() * this.height) + this.y - 16));
    		    }
    		    if(explosionCounter >= 12) {
    		        myStatus = 'DEAD';
    			myMap.updateStatus(COMPLETE);
    		        myMap.removeFromMap(this);
    		    }   
    		}
                animate();
	    } else {
		frameCount++;
	    }
	}
	
	override public function moveMe():void {
	    frameCount++;
	    if(frameCount >= frameDelay) { 
		if(actionCounter >= actionDelay) { // if we've waited long enough
		    if(currentAction == JUMPING) { // and we're jumping
			setLoop(0, 2, 3, 2, 0); // make us point
			currentAction = POINTING; // switch us to pointing mode
		    } else if(currentAction == POINTING) { // otherwise, if we're pointing
			setLoop(0, 0, 1, 0, 0); // make us jump
			currentAction = JUMPING; // and switch us to jumping mode
		    }
		    actionCounter = 0;
		}
		
    		frameStarted = true;
		statusSet = false;

		this.y += vely / 2; // update our y variable
    		
    		notifyObservers(); // tell everybody where we are now
    		applyPhysics(); // apply our enviromental variables
		updateStatus(); // update our status

		frameCount = 0;
		frameStarted = false;
		actionCounter++;
	    }
	    animate();
	    
	}
        
    }
    
}