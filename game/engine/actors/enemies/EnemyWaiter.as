package engine.actors.enemies {
    
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
    import engine.actors.geoms.*;
    import engine.actors.enemies.EnemyWalker;
    
    public class EnemyWaiter extends EnemyWalker implements ISubject, IObserver {
        
        private var observers:Array = new Array();
        private var speed:Number = 1;
        
        private var frameCount:int = 0;
        private var frameDelay:int = 0;
        
        private var groundCollide:Boolean;
        
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
		
		public function update():void {
		    groundCollide = false;
		    if(frameCount >= frameDelay) {
		        this.x += speed;
		        frameCount = 0;
		    } else {
		        frameCount++;
		    }
		    
		    notifyObservers();
		    if(!groundCollide) {
		        speed *= -1;
		    }
		}
        
    }
    
}