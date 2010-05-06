package {

	import engine.Game;
	import engine.maps.scrnStart;

	public class gatsby extends Game {
		
		public function gatsby() {
			//start!
			stage.addChild(new scrnStart(this));
		}
	}//end class
}//end package