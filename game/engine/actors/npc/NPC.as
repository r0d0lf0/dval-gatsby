package engine.actors.npc {
    
    import engine.actors.Actor;
    import engine.actors.DialogBox;
    import engine.IObserver;
	import controls.KeyMap;
    import engine.actors.player.Hero;
    
    public class NPC extends Actor implements IObserver {
        
        protected var hitYet = false;
        protected var dialogBox = new DialogBox();
        
        public function NPC() {
            // i live
        }
        
        override public function notify(subject:*):void {
            if(!hitYet) {
                if(checkCollision(subject) && subject is Hero) {
                    dialogBox.start();
                    hitYet = true;
                }   
            }
        }
        
        override public function update():void {
            
        }
        
    }
    
}