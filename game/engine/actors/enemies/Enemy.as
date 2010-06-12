package engine.actors.enemies {
    
    import engine.actors.Actor;
    
    public class Enemy extends Actor {
        
        protected var HP:Number = 10;
        protected var attack_strength:Number = 1;
        
        public function Enemy() {
            trace("Enemy created.");
        }
        
        // this should get the enterFrame tick like everything else
        override public function update():void {

        }
        
        // the hero will use this to deal damage
        public function receiveDamage(damage:Number) {
            HP -= damage;
            if(HP <= 0) {
                HP = 0;
            }
        }
        
        public function notify(subject):void {

        }
        
    }
    
}