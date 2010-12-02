package engine.maps {
    
    import engine.Map;
    import engine.actors.player.Hero;

    public class level3_map4 extends Map {
		
		override public function customUpdate():void {
		    // this will be replaced later
            // by children of this class, should they
            // require it
            //skyPlane.x++;
		}
				
		override public function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
		    heroHP = scoreboard.getHP();
    		updateSubscriptions();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		override public function notify(subject:*):void {
		    if(subject is Hero) {
		        //moveMap(subject);
				if(subject.x + subject.collide_right >= 256) {
					subject.x = 256 - subject.collide_right;
				}
		        if(heroHP != scoreboard.getHP()) { // if our hero's HP has changed
		            heroHP = scoreboard.getHP(); // reset our holder for HP
		            notifyObservers(); // and tell the level about it
		        }
		    }
		}
        
    }
    
}