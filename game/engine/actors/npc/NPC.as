package engine.actors.npc {
    
    import engine.actors.Animatable;
    import engine.actors.player.Hero;
    
    public class NPC extends Animatable {
        
        public var hitYet = false;
        protected var triggeredYet = false;
        protected var dialogBox;
        
        public function collisionAction() {
            // this will get overwritten later
        }
        
        override public function notify(subject:*):void {
            if(!hitYet) { // if nobody's collided with me yet
                if(checkCollision(subject) && subject is Hero) { // and I'm colliding with a Hero
                    collisionAction(); // do something important
                    hitYet = true; // then let us know we've been hit
                }   
            }
        }
        
        override public function update():void {
            // if we need to do anything
        }
        
    }
    
}