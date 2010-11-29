package engine{

    import flash.display.MovieClip;
    import engine.IObserver;
    import engine.ISubject;
    
	public dynamic class Screen extends MovieClip implements ISubject, IObserver {
        
        public static const DEFAULT = 1;
        public static const ACTIVE = 2;
        public static const PAUSING = 30;
        public static const PAUSED = 31;
        public static const COMPLETE = 4;
        public static const HERO_DEAD = 5;
        public static const GAME_OVER = 6
        
        public var status = DEFAULT; // default status, i sort of forget what this is for
		public var prevStatus = DEFAULT; // holder for previous status
		
		public var observers:Array = new Array(); // this is the array of objects subscribed to this map
        
        public function Screen() {
            
        }
        
        public function getStatus() {
		    return status;
		}
        
        public function isObserver(observer):Boolean {
		    for(var ob:int=0; ob<observers.length; ob++) {
		        if(observers[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
		}
		
		
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1);
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
		public function notify(subject:*):void {
            // this will get overwritten
		}
		
		public function updateStatus(newStatus) {
		    prevStatus = status;
		    status = newStatus;
		}
		
		public function update(evt = null):Boolean {
            return true; // this will get overwritten by the child class
		}
        
    }
    
}