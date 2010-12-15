package engine.actors.npc {
    
    import engine.actors.npc.NPC;
    import engine.actors.DialogBox;
    
    public class NPCLibraryMan extends NPC {
       
       override public function setup() {
           collide_left = 10; // what pixel do we collide on on the left
   	       collide_right = 22; // what pixel do we collide on on the right
   		
   		   myName = "LibraryMan"; // the generic name of our enemy
           mySkin = "LibraryManSkin"; // the name of the skin for this enemy
   		
   		   startFrame = 0; // the first frame to loop on
           endFrame = 2; // the final frame in the row
           nowFrame = 0; // current frame in row
           loopFrame = 0; // frame at which to loop
           loopType = 1; // 0 loops, 1 bounces
           loopRow = 0; // which row are we on
           loopDir = 1; // loop forward (to the right) by default
           speed = 10; // 5 replaced // how many frames should go by before we advance
           
           tilesWide = 1;
   	       tilesTall = 2;
       }
       
       override public function collisionAction() {
           if(!triggeredYet) {
               var dialogBox = new DialogBox();
               myMap.spawnActor(dialogBox, myMap.getViewportCoords(), this.y - 120); // spawn our dialog box on the map
                                            // it will initially start at 0, 0, but we'll
                                            // put logic in the Map class about how to handle
                                            // dialog boxes.  I don't know if this is the right
                                            // place for this to live, but it seems like it'll work
               dialogBox.setText(new Array(
                   'IT\'S A BONA-FIDE PIECE OF\nPRINTED MATTER. IT FOOLED\nME. THIS FELLA\'S A REGULAR\nBELASCO. IT\'S A TRIUMPH.',
                   'WHAT THOROUGHNESS! WHAT\nREALISM! KNEW WHEN TO STOP,\nTOO-DIDN\'T CUT THE PAGES.\nBUT WHAT DO YOU WANT?',
                   'WHAT DO YOU EXPECT?\n\nLOOK FOR GATSBY IN THE GARDEN.'
                   ));                             
               triggeredYet = true;
           }
       }
       
       override public function update():void {
           animate();
       }
    
        
    }
    
}