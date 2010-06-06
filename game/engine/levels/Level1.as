package engine.levels{
	
	//import flash.display.MovieClip;
	import engine.Level;
	import engine.screens.*;
	import managers.MapManager;
	import managers.TimerManager;
	
	public class Level1 extends Level {
	    
		public function Level1():void{
		    super();
		    mapList = new Array('Level1_Map1', 'Level1_Map2', 'Level1_Map3'); // use this later for dylan-style level loading by converting strings to classes
			currentScreen = new LevelStart(); // we're just starting, so our current
			addChild(currentScreen);
			currentScreen.y += 32;
		}
		
		public override function update():Boolean {
		    if(!currentScreen.update()) { // update the current screen to see if it's finished
		        switch(currentScreen.getStatus()) {
		            case 'COMPLETE': // if our map returned COMPLETE
		                currentMapIndex++; // increment the current map index
		                if(currentMapIndex < mapList.length) { // and if we haven't finished the last map
		                    removeChild(currentScreen); // remove the current map
		                    currentScreen = getMap(currentMapIndex);  // get the next one
                            addChild(currentScreen); // add the new child
                            currentScreen.y += 32; // move the screen down so that it doesn't cover the scoreboard
		                    return true; // and return true
		                } else { // otherwise, we've completed the final map so
		                    setStatus('COMPLETE');  // set the level exit status to COMPLETE
		                    return false; // and return false to the Engine
		                }
		                break;
		            case 'HERO DEAD': // if the map returns HERO DEAD
		                setStatus('HERO DEAD');  // set the level exit status to HERO DEAD
		                return false; // and return false to the Engine
		                break;
		        }
		    }
		    scoreboard.setLives(5);
		    return currentScreen.update();

		}

		private function getMap(mapIndex) {
		    switch(mapIndex) {
		        case 1:
		            return new level1_map1();
		        case 2:
		            return new level1_map1();
		        case 3:
		            return new level1_map1();
		    }
		    return false;
		}
		
	}//end class
}//end package