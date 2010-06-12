package engine.actors.enemies {
    
    import engine.IObserver;
    import engine.ISubject;
    
    public class EnemyWaiter extends EnemyWalker implements ISubject, IObserver {
        
        private var observers:Array = new Array();
        private var speed:Number = -1;
        
        private var frameCount:int = 0;
        private var frameDelay:int = 2;
        
        public function EnemyWaiter() {
            super();
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
		    
		}
		
		override public function update():void {
		    if(frameCount >= frameDelay) {
		        this.x += speed;
		        frameCount = 0;
		    } else {
		        frameCount++;
		    }
		    
		    if(x < 0) {
		        speed = 1;
		    }
		    
		}
        
    }
    
}