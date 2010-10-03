package engine {
    
    public class Scoreboard implements ISubject {
        
        private static var _instance:Scoreboard;
        public static var score:int = 0;
        public static var lives:int = 3;
        public static var HP:int = 3;
        private static var observers:Array = new Array();
        
        public function Scoreboard(pvt:PrivateClass) {
            
        }
        
        public static function getInstance():Scoreboard {
            if(Scoreboard._instance == null) {
                Scoreboard._instance = new Scoreboard(new PrivateClass());
                trace("Scoreboard instantiated.");
            }
            return Scoreboard._instance;
        }
        
        public function setHP(HP) {
            Scoreboard.HP = HP;
            notifyObservers();
        }        
        
        public function getHP():Number {
            return Scoreboard.HP;
        }
        
        public function addToScore(amount:Number) {
            Scoreboard.score += amount;
            notifyObservers();
        }
        
        public function setScore(newScore:Number) {
            Scoreboard.score = newScore;
            notifyObservers();
        }
        
        public function getScore() {
            return Scoreboard.score;
        }
        
        public function removeLife() {
            Scoreboard.lives--;
            notifyObservers();
        }
        
        public function addLife() {
            Scoreboard.lives++;
            notifyObservers();
        }
        
        public function getLives() {
            return Scoreboard.lives;
        }
        
        public function setLives(newLives) {
            Scoreboard.lives = newLives;
        }
        
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		public function isObserver(observer):Boolean {
		    for(var ob:int=0; ob<observers.length; ob++) {
		        if(observers[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
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
        
    }
    
}

class PrivateClass {
    public function PrivateClass() {
        trace("Private class is up.");
    }
}