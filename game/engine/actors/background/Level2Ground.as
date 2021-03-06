package engine.actors.background {
    
    import engine.actors.Actor;
    import engine.Map;
    import engine.IObserver;
    import engine.actors.player.Hero;
    
    public class Level2Ground extends Actor implements IObserver {
        
        private var playerOffset = 0;
        private var speed = 3;
        private var loopPoint = 320;
        
        public function Level2Ground() {
            trace("ground created");
        }
        
        override public function notify(subject:*):void {
            if(subject is Hero) {
                playerOffset -= speed;
                if(playerOffset <= -loopPoint) {
                    playerOffset = -(-playerOffset - loopPoint)
                }
                this.x = playerOffset;
            } if(subject is Map) {
                trace("Map!");
            }
        }
        
        override public function update():void {
            
        }
        
    }
    
}