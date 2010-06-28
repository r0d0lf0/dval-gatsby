package engine.actors.specials {
    
    import engine.actors.Actor;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.player.Hero;
    
    public class ScorePowerup extends Actor implements IObserver {
        
        public var points = 10;
        private var taken = false;
        
        public function ScorePowerup() {
            // i construct, therefore, i am.
            trace("powerup!");
        }
        
        public function notify(subject:*):void {
            if(!taken && subject is Hero) {
                if(checkCollision(subject)) {
                    subject.receivePowerup(this);
                    taken = true;
                }   
            }
        }
        
    }
    
}