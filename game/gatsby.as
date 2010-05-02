package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import engine.Game;
	//import engine.Map;
	import engine.maps.lvl1_1;
	//import maps.lvl1_2;

	public class gatsby extends Game {
		
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