package engine.actors.enemies {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.geoms.*;
    import flash.events.Event;
    
    public class EnemyMaleDancer extends EnemyWalker implements ISubject, IObserver {
        
        private var observers:Array = new Array();
        private var walkSpeed:Number = 1;
        private var walkDir:int = -1;
        
        private var frameCount:int = 0;
        private var frameDelay:int = 0;
        private var danceCount:int = 0;
        
        private var groundCollide:Boolean;
        
        public function EnemyMaleDancer() {
			if (stage != null) {
				setup();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			setup();
		}
		
		private function setup() {
		    setSkin('MaleDancerSkin',2,2);
		    setLoop(0, 0, 2, 0, 1);
		    trace("Dancer setup.");
		}
        
        public function addObserver(observer):void {
		    observers.push(observer);
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1); break;
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
		override public function notify(subject):void {
		    if(checkCollision(subject)) {
		        if(subject is Hero) {
		            subject.receiveDamage(1);
		        }
            }
		}
		
		public function collide(subject) {
		    if(subject is Cloud) {
		        if(!groundCollide) {
    		        groundCollide = true;
    		    }
		    }
		}
		
		override public function update():void {
		    animate();
		    groundCollide = false;
		    if(frameCount >= frameDelay) {
		        this.x += walkSpeed * walkDir;
		        frameCount = 0;
		        danceCount++;
		    } else {
		        frameCount++;
		    }
		    
		    if(danceCount >= 100) {
		        loopRow = loopRow == 0;
		        danceCount = 0;
		    }
		    
		    notifyObservers();
		    if(!groundCollide) {
		        walkDir = walkDir * -1;
		    }
		}
        
    }
    
}