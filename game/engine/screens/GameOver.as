package engine.screens {
    
    import flash.display.MovieClip;
    import engine.Screen;
    
    public class GameOver extends Screen {
        
        private var counter:Number = 0;
        
        public function GameOver() {
            updateStatus(ACTIVE);
        }
        
        override public function update(evt = null):Boolean {
            counter++;
            if(counter > 120) {
                updateStatus(GAME_OVER);
                return false;
            } else {
                return true;
            }
        }
        
    }
    
}