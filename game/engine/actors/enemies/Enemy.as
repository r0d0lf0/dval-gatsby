package engine.actors {
    
    public class Enemy extends MapObject {
        
        protected var HP:Number = 10;
        protected var attack_strength:Number = 1;
        
        public function Enemy() {
            trace("Enemy created.");
        }
        
        // this should get the enterFrame tick like everything else
        public function update() {
            if(!HP) {
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
        
    }
    
}