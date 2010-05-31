package engine {
    
    import flash.display.MovieClip;
    import flash.events.Event;
    import engine.*;
    import engine.actors.*;
	import engine.assets.*;
    
    public class GameEngine extends MovieClip {
        
        private var hero:Hero;
        private var assets:Array;
        private var current_level;
        private var game_started:Boolean;
        private var current_asset = 0;
        
        public function GameEngine(hero, assets) {
            
            this.hero = hero;
            this.assets = assets;
            this.addChild(assets[current_asset]);
        }
        
		public function start() {   
		   
		}
		
		public function update(e) {
		    
		    // update the asset, if it returns false, see why it stopped
		    if(!assets[current_asset].update()) {
		        switch(assets[current_asset].getStatus()) {
		            case 'COMPLETE':
		                if((current_asset + 1) == assets.length) {
		                    trace("You win."); // you've beaten the game, end it
		                    return false;
		                } else {
		                    current_asset++; // otherwise, move to the next asset
		                }
		                break;
		            case 'HERO_DIED':
		                if(!1) {
		                    removeEventListener(Event.ENTER_FRAME, update);
		                    return false; // we're out of lives, game over
		                } else {
		                    assets[current_asset].restart(); // restart the level
		                }
		                break;
		            default:
		                trace("Invalid status code thrown by asset: " + assets[current_asset].getStatus());
		        }
		        
		    }
		    
		}
        
    }
    
}