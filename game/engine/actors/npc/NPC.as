package engine.actors.npc {
    
    import engine.actors.Actor;
    import engine.actors.DialogBox;
    import engine.IObserver;
	import controls.KeyMap;
    import engine.actors.player.Hero;
    
    public class NPC extends Actor implements IObserver {
        
        protected var hitYet = false;
        
        public function NPC() {
            // i live
        }
        
        public function collisionAction() {
            // this will get overwritten later
        }
        
        override public function notify(subject:*):void {
            if(!hitYet) {
                if(checkCollision(subject) && subject is Hero) {
                    hitYet = true;
                    collisionAction();
                }   
            }
        }
        
        override public function update():void {
            
        }
        
    }
    
}