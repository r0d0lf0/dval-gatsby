package engine.actors.specials {
    
    import engine.actors.Actor;
    
    public class HealthPowerup extends Actor implements IActor, IObserver {
        
        public function HealthPowerup() {
            // i construct, therefore, i am.
        }
        
        public function act():Boolean {
            return true;
        }
        
        public function notify(subject:Subject):void {
            if(checkCollision(subject)) {
                // increment health by 1
                // disappear
            }
        }
        
        private function checkCollision(subject):Boolean {
            // check for a collision with the subject
        }
        
    }
    
}