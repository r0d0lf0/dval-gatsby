package{
	
	import flash.display.MovieClip;
	import managers.ScreenManager;
	
	public class Game extends MovieClip{
	
		scrnManager:ScreenManager = new ScreenManager();
	
		public function Game():void{
			
			addChild(scrnManager);
			
		}
		
	}//end class
}//end package