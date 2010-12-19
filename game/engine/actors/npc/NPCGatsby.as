package engine.actors.npc {
    
    import engine.actors.npc.NPC;
    import engine.actors.DialogBox;
    
    public class NPCGatsby extends NPC {
       
       override public function setup() {
           collide_left = 0; // what pixel do we collide on on the left
   	       collide_right = 24; // what pixel do we collide on on the right
   		
   		   myName = "Gatsby"; // the generic name of our enemy
           mySkin = "GatsbySkin"; // the name of the skin for this enemy
   		
   		   startFrame = 0; // the first frame to loop on
           endFrame = 3; // the final frame in the row
           nowFrame = 0; // current frame in row
           loopFrame = 0; // frame at which to loop
           loopType = 1; // 0 loops, 1 bounces
           loopRow = 0; // which row are we on
           loopDir = 1; // loop forward (to the right) by default
           speed = 10; // 5 replaced // how many frames should go by before we advance
           
           tilesWide = 1;
   	       tilesTall = 3;
       }
       
       override public function update():void {
           // if we need to do anything
           animate();
       }
       
       override public function collisionAction() {
           trace("gatsby hit");
           if(!triggeredYet) {
               dialogBox = new DialogBox();
               myMap.spawnActor(dialogBox, myMap.getViewportCoords(), this.y - 120); // spawn our dialog box on the map
                                            // it will initially start at 0, 0, but we'll
                                            // put logic in the Map class about how to handle
                                            // dialog boxes.  I don't know if this is the right
                                            // place for this to live, but it seems like it'll work
                dialogBox.setText(new Array(
                   'GOOD JOB, OLD SPORT!' 
                ));
                dialogBox.setExitFunction(dialogBox.EXIT);
                triggeredYet = true;
            }
       }
        
    }
    
}