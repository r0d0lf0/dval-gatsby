package engine.assetPrototypes {
    
    import controls.KeyMap;
    import engine.assetPrototypes.IGameAsset;
    import flash.events.Event;
	import flash.display.MovieClip;
    import flash.display.Stage;
    
    public class Asset extends MovieClip implements IGameAsset {
        
        protected var game;
        protected var status;
        protected var keys:KeyMap = new KeyMap(); // Assets should be the only guys with the KeyMap
                                                // since they are the only ones guaranteed to exist
        public function Asset(game) {
            status = "UNCONFIGURED";
            this.game = game;
            if (stage != null) {
				config();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
            
        }
        
        private function addedToStage(evt):void {
      		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
            config();
        }
        
        private function config():void {
            trace("Asset Created.");
            this.addChild(keys);
			keys.addEventListener(KeyMap.KEY_UP, onKeyRelease); // attatch our keyboard functions, we'll route them
			keys.addEventListener(KeyMap.KEY_DOWN, onKeyPress); // elsewhere later if we need them
		    status = "ACTIVE";
		}
		
		private function onKeyRelease(e) {
		    //trace("released!");
		}
		
		private function onKeyPress(e) {
            //trace("You pressed the " + keys.getLastKey() + " key.");
		}
        
        public function update():Boolean {
            return true;
        }
        
        public function getStatus():String {
            return status;
        }
        
        public function attachgame(game) {
            this.game = game;
        }
        
        
    }
    
}