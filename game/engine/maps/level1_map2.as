package engine.maps {
    
    import engine.Map;
    import engine.actors.background.*;
    import engine.actors.enemies.*;


    public class level1_map2 extends Map {
		
		override public function customUpdate():void {
		    // this will be replaced later
            // by children of this class, should they
            // require it
            //skyPlane.x++;
		}
		
		private function dropEnemy(enemy, x, y) {
			var currentEnemy;
			
			switch(enemy) {
				case 'EnemyFemaleDancer':
					currentEnemy = new EnemyFemaleDancer();
					break;
				case 'EnemyMaleDancer':
					currentEnemy = new EnemyMaleDancer();
					break;
				case 'EnemyWaiter':
					currentEnemy = new EnemyWaiter();
					break
				default:
					currentEnemy = new EnemyWaiter();
					break;
			}
			
			currentEnemy.alwaysOn = true;
			this.addChild(currentEnemy);
			currentEnemy.x = x;
			currentEnemy.y = y;
		}
		
		override public function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
			dropEnemy('EnemyFemaleDancer', 1168, 144);
			dropEnemy('EnemyMaleDancer', 1192, 144);
			
			dropEnemy('EnemyFemaleDancer', 1464, 144);
			dropEnemy('EnemyMaleDancer', 1488, 144);
			
			dropEnemy('EnemyFemaleDancer', 1328, 144);
			dropEnemy('EnemyMaleDancer', 1352, 144);
			
			dropEnemy('EnemyWaiter', 1424, 144);
		
		    heroHP = scoreboard.getHeroHP();
    		updateSubscriptions();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
        
    }
    
}