package engine.maps {
    
    import engine.Map;
    import engine.actors.background.*;
    import engine.actors.enemies.*;


    public class level3_map2 extends Map {
	
	override public function customUpdate():void {
	    // this will be replaced later
            // by children of this class, should they
            // require it
            //skyPlane.x++;
	}
	
	override public function buildMap():void {
	    spawnMoneyBag(256, -24, 320, 48);
	    heroHP = scoreboard.getHeroHP();
    	    updateSubscriptions();
    	    updateStatus(ACTIVE);
    	    prevStatus = ACTIVE;
	    notifyObservers(); // tell our observers that we've completed our load out
	}
        
    }
    
}