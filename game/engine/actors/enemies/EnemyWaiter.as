package engine.actors.enemies {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.geoms.*;
    import flash.events.Event;
    
    public class EnemyWaiter extends EnemyWalker implements ISubject, IObserver {
        
        private var observers:Array = new Array();
        private var walkSpeed:Number = 1;
        
        private var frameCount:int = 0;
        private var frameDelay:int = 0;

        private var groundCollide:Boolean;
        
        public function EnemyWaiter() {
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
		    collide_left = 10; // what pixel do we collide on on the left
    		collide_right = 22; // what pixel do we collide on on the right
		    setSkin('WaiterSkin',2,2);
		    setLoop(0, 0, 1, 0, 0);
		    trace("Waiter setup.");
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
                subject.receiveDamage(1);
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
		    
		    if(frameCount >= frameDelay) {
		        this.x += walkSpeed;
		        frameCount = 0;
		        notifyObservers();
    		    if(!groundCollide) {
    		        walkSpeed *= -1;
    		        if(walkSpeed > 0) {
    		            goingLeft = 0;
    		        } else {
    		            goingLeft = 1;
    		        }
    		    }
		    } else {
		        frameCount++;
		    }
		    groundCollide = false;
		}
        
    }
    
}