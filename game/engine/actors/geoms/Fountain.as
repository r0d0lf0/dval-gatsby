package engine.actors.geoms {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.Animatable;
    import engine.actors.geoms.*;
    import flash.events.Event;
    
    public class Fountain extends Animatable implements ISubject, IObserver {
		
        private var observers:Array = new Array();
        private var velocity = 1;
	
		public function Fountain() {
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
		    tilesWide = 1;
    		tilesTall = 2;
		    setSkin('FountainSkin',1,2);
		    setLoop(0, 0, 2, 0, 0);
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
		
		public function notify(subject):void {
		    if(checkCollision(subject)) {
                subject.collide(this);
            }
		}
		
		override public function update():void {
		    animate();
		    if(this.y < 50) {
		        velocity = 1;
		    } else if(this.y > 140) {
		        velocity = -1;
		    }
		    this.y += velocity;
		}
	}
}