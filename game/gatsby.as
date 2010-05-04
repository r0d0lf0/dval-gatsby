package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import engine.Game;
	import engine.maps.*;

	public class gatsby extends Game {
		//load game vars into 'global' memory
		
		private var startSplash:MovieClip = new StartScreen();
		
		public function gatsby() {
			//
			stage.addChild(startSplash);
			startSplash.start_btn.addEventListener(MouseEvent.CLICK, startHandler);
		}
		private function startHandler(mevt:MouseEvent):void {
			
			startSplash.start_btn.removeEventListener(MouseEvent.CLICK, startHandler);
			stage.removeChild(startSplash);
			loadLevel(new lvl1_1(this));
		}
	}//end class
}//end package