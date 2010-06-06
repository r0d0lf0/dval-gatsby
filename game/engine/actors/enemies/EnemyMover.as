package engine.actors {
    
    public class EnemyMover extends Enemy implements IObserver {
        
        private var current_direction = "RIGHT";
        private var move_speed = 2;
        private var move_velocity = 2;
        
        public function EnemyMover() {
            trace("Enemy Mover Created.");
        }
        
        public function notify(subject):void {
            trace("I've been notified.");
            if(checkCollision(subject)) {
                if(subject is Hero) {
                    subject.recieveDamage(this.attack_strength);
                } else {
                    changeDirection(); // if we bump into anything but the hero, just turn around
                }
            }
        }
        
        public override function update():Boolean {
            move();
            super(); // the super function checks for HP remaining, and deals with death
        }
        
        private function move() {
            this.x += walk_velocity;
        }
        
        private function changeDirection() {
            if(current_direction == "RIGHT") {
                current_direction == "LEFT";
                walk_velocity = -walk_speed;
            } else {
                current_direction = "RIGHT";
                walk_velocity = walk_speed;
            }
        }
        
        private function animate() {
            // animate junk here, probably just reading direction, unless
            // there are certain attack animations or something
        }
        
    }
    
}