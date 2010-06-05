package{
	
	import flash.display.MovieClip;
	import managers.ScreenManager;
	
	public class Game extends MovieClip {
	
		public var scrnManager:ScreenManager = new ScreenManager();
	
		public function Game():void{
			
			addChild(scrnManager);
			
			scrnManager.getScreens();
			scrnManager.setScreen('gameOpen');
			
		}
		
	}//end class
}//end package