package engine.actors {
    
    public class Enemy extends Actor implements IObserver {
        
        protected var HP:Number = 10;
        protected var attack_strength:Number = 1;
        
        public function Enemy() {
            trace("Enemy created.");
        }
        
        // this should get the enterFrame tick like everything else
        public function update() {
            // if we're alive, keep on trucking.  otherwise, die.
            if(HP <= 0) {
                return false;
            } else {
                return true;
            }
        }
        
        // the hero will use this to deal damage
        public function receiveDamage(damage:Number) {
            HP -= damage;
            if(HP <= 0) {
                HP = 0;
            }
        }
        
        public function notify(subject):void {
            trace("I've been notified.");
        }
        
        private function checkCollision(subject) {
            // check to see if we've collided with our subject, if we have
            // you should probably damage him, or maybe if he jumps from the
            // top, he can squish you.  Whatevs.
        }
        
    }
    
}