package engine.actors.enemies {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import flash.events.Event;
    
    public class EnemyFemaleDancer extends EnemyWalker implements ISubject, IObserver {
        
        private var danceCount:int = 0;
		
		override public function setup() {
		    
		    myName = "EnemyFemaleDancer"; // the generic name of our enemy
            mySkin = "FemaleDancerSkin"; // the name of the skin for this enemy
		    
		    startFrame = 0; // the first frame to loop on
            endFrame = 0; // the final frame in the row
            nowFrame = 0; // current frame in row
            loopFrame = 0; // frame at which to loop
            loopType = 1; // 0 loops, 1 bounces
            loopRow = 0; // which row are we on
            loopDir = 1; // loop forward (to the right) by default
            speed = 5; // how many frames should go by before we advance
		}
        
    }
    
}