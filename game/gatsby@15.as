package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import engine.Game;
	import engine.maps.scrnStart;

	public class gatsby extends Game {
		//load game vars into 'global' memory
		
		private var startSplash:scrnStart = new scrnStart(this);
		
		public function gatsby() {
			//
			stage.addChild(startSplash);
		}
	}//end class
}//end package