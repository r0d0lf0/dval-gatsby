package engine.screens {
    
    import flash.display.MovieClip;
    import engine.IScreen;
    
    public class GameOver extends MovieClip implements IScreen {
        
        private var counter:Number = 0;
        private var status:String = "UNINITIALIZED"
        
        public function GameOver() {
            status = "ACTIVE";
        }
        
        public function update():Boolean {
            counter++;
            if(counter > 120) {
                status = 'COMPLETE';
                return false;
            } else {
                return true;
            }
        }
        
        public function getStatus():String {
            return status;
        }
        
        public function restart():void {
            
        }
        
    }
    
}