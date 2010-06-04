
// this is the old start statement
package {

	import engine.NewGame;
    import flash.events.Event;
	import flash.display.MovieClip;
	
	public class GatsbyNew extends MovieClip {
	
	    private var game:NewGame;
		
		public function GatsbyNew() {
			//start!
			if (stage != null) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage() {
		    removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		    init();
		}
		
		private function init() {
		    game = new NewGame(this);
            this.addChild(game);
    	    trace("initialized.");
		}
	}//end class
}//end package


