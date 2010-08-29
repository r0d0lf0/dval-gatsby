package engine.actors.specials {
    
    import engine.actors.Actor;
    import engine.IObserver;
    import engine.Scoreboard;
    
    public class HealthPowerup extends Actor implements IObserver {
        
        public var health = 1;
        private var taken = false;
        
        public function HealthPowerup() {
            // i construct, therefore, i am.
            trace("powerup!");
        }
        
        override public function notify(subject:*):void {
            if(!taken) {
                if(checkCollision(subject)) {
                    subject.receivePowerup(this);
                    taken = true;
                }   
            }
        }
        
    }
    
}