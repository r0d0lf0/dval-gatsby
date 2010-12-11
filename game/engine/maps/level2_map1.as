package engine.maps {
    
    import engine.Map;
    import engine.actors.background.*;
    import engine.actors.player.Hero;
    import engine.actors.specials.Door;
    
    public class level2_map1 extends Map {
        
        private const fadeLevels = 6;
        private var currentFadeLevel = 0;
        private var fadeSpeed = 15;
        private var fadeCounter = 0;
        private var fadeEnabled = false;
        
        private var groundPlane = new Level2Ground();
        private var groundSpeed = 9;
        private var groundLoop = 320;
        private var groundCounter = 0;
        
        private var treePlane = new Level2Trees();
        private var treeSpeed = 4;
        private var treeLoop = 400;
        private var treeCounter = 0;
        
        
        private var skyPlane = new Level2Sky();
        private var skyLoop = 400;
		private var skySpeed = 1;
		private var skyCounter = 0;
		
		override public function customUpdate():void {
		    // this will be replaced later
            // by children of this class, should they
            // require it
            //skyPlane.x++;
            //moveSky();
            //moveTrees();
            if(fadeEnabled) {
                fadeCounter++;
                if(fadeCounter > fadeSpeed) {
                    fadeCounter = 0;
                    currentFadeLevel++;
                    if(currentFadeLevel > fadeLevels) {
                        currentFadeLevel = 0;
                        updateStatus(COMPLETE);
                    }
                    skyPlane.setLoop(currentFadeLevel, 0, 0, 0, 0);
                    treePlane.setLoop(currentFadeLevel, 0, 0, 0, 0);
                }   
            } else {
                moveGround();
            }
		}
		
		private function moveSky() {
		    skyCounter += skySpeed;
		    if(skyCounter >= skyLoop) {
		        skyCounter = skyLoop - skyCounter;
		    }
		    skyPlane.x = (getViewportCoords() - 16) - skyCounter;
		}
		
		private function moveTrees() {
		    treeCounter += treeSpeed;
		    if(treeCounter >= treeLoop) {
		        treeCounter = treeLoop - treeCounter;
		    }
		    treePlane.x = (getViewportCoords() - 16) - treeCounter;
		}
		
		private function moveGround() {
		    groundCounter += groundSpeed;
		    if(groundCounter >= groundLoop) {
		        groundCounter = groundLoop - groundCounter;
		    }
		    groundPlane.x = (getViewportCoords() - 16) - groundCounter;
		}
		
		override public function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
		    heroHP = scoreboard.getHP();
		    spawnActor(skyPlane);
		    spawnActor(treePlane);
		    treePlane.y = 48;
		    this.addChild(groundPlane);
		    groundPlane.y = 208 - groundPlane.height;
		    setChildIndex(skyPlane,0);
		    setChildIndex(treePlane,0);
		    setChildIndex(groundPlane,0);
    		updateSubscriptions();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
        
    }
    
}