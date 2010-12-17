package engine.actors.specials {
    
    import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.Scoreboard;
    import engine.IObserver;
    import engine.ISubject;
    
    public class HealthPowerup extends Actor implements IObserver, ISubject {
        
        private var scoreboard:Scoreboard;
        private var observers:Array = new Array();
        
        public function HealthPowerup() {
            // i construct, therefore, i am.
            scoreboard = Scoreboard.getInstance();
        }
        
        public function notify(subject):void {
            if(subject is Hero) {
                if(checkCollision(subject)) {
                    scoreboard.addHP(1);
                    trace("Health Collision!");
                }
            }
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
        
    }
    
}