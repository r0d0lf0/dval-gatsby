package engine.actors.enemies {
    
    import engine.actors.Animatable;
    
    
    public class Enemy extends Animatable {
        
        protected var HP:Number = 1;
        protected var attack_strength:Number = 1;
        
        protected var deadFlag:Boolean = false;
        
        public function Enemy() {
            trace("Enemy created.");
        }
        
        // this should get the enterFrame tick like everything else
        override public function update():void {

        }
        
        override public function checkCollision(subject) {
            if(Math.abs((subject.x + (.25 * subject.width)) - (this.x + (.25 * this.width))) <= this.width/2) {
                if(Math.abs(subject.y - this.y) <= 32) {
                    return true;
                }
            }
        }
        
        // the hero will use this to deal damage
        public function receiveDamage(damage:Number) {
            HP -= damage;
            if(HP <= 0) {
                HP = 0;
                trace("I'm dead!");
            }
        }
        
        public function notify(subject):void {

        }
        
    }
    
}