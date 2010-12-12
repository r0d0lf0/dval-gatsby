package engine.maps {
    
    import engine.Map;
    import engine.actors.player.Hero;
	import engine.actors.enemies.EnemyBossWolfsheim;
	import engine.actors.EnemyFactory;

    public class level3_map4 extends Map {
	
		protected var EnemyBoss;
		protected var enemyFactories = new Array();
		protected const factoryCount = 2;
		
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
		    heroHP = scoreboard.getHeroHP();
    		updateSubscriptions();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		private function getWolfsheim() {
			for(var i = 0; i < observerArray.length; i++) {
				if(observerArray[i] is EnemyBossWolfsheim) {
					return observerArray[i];
					break;
				}
			}
		}
		
		override public function notify(subject:*):void {
		    if(subject is Hero) {
		        //moveMap(subject);
				if(subject.x + subject.collide_right >= 256) {
					subject.x = 256 - subject.collide_right;
				}
		        if(heroHP != scoreboard.getHeroHP()) { // if our hero's HP has changed
		            heroHP = scoreboard.getHeroHP(); // reset our holder for HP
		            notifyObservers(); // and tell the level about it
		        }
		    } else if(subject is EnemyBossWolfsheim) {
				if(EnemyBoss == null) {
					EnemyBoss = subject;
				}
			} else if(subject is EnemyFactory) { // if a factory's all done
				if(!isListed(subject)) { // and we don't yet have a record of it
					enemyFactories.push(subject); // add it to our dead factories list
					trace("Factory empty!"); // and send up a flare
					if(enemyFactories.length >= factoryCount) { // if all our factories are empty
						EnemyBoss.killMe(); // kill the boss
					}
				}				
			}
		}
		
		private function isListed(factory:*) {
			for (var ob:int=0; ob<enemyFactories.length; ob++) { // loop through all of our enemies
                if(enemyFactories[ob] == factory) { // and if we find this one
					return true;
				}
			}
			return false;
		}
        
    }
    
}