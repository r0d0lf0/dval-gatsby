/*
// this is the old start statement
package {

	import engine.Game;
	import engine.maps.scrnStart;

	public class gatsby extends Game {
		
		public function gatsby() {
			//start!
			newLevel(new scrnStart(this));
		}
	}//end class
}//end package
*/

// here's the new one
package {

	import engine.NewGame;
	//import engine.maps.scrnStart;

	public class gatsby extends NewGame {
		
		private var game:NewGame;
		
		public function gatsby() {
			//start!
			game = new NewGame();
			//game.start();
			
		}
	}//end class
}//end package

