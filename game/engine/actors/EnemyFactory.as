package engine.actors {
    
    import engine.actors.Actor;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import engine.actors.enemies.EnemyBlacksox;
	import engine.actors.enemies.EnemyPitcher;
	import engine.Scoreboard;
    
    public class EnemyFactory extends Actor {
                
		protected var spawnCount = 0;
		protected var deathCount = 0;
		protected const spawnMax = 4;
		protected const simultaneousSpawnMax = 3;
		protected const simultaneousPitcherMax = 1;
		protected const spawnDelay = 45;
		protected var actionCounter = 60;
		protected var enemiesRoster = new Array();
		protected var currentEnemy;
		protected var pitcherCount = 0;
		
		protected const ACTIVE = 10;
		protected const EMPTY = 20;
		protected const DEAD = 30;
		protected var spawnStatus = ACTIVE;
		protected var scoreboard = Scoreboard.getInstance();
		protected var initialBossHP;

        public function EnemyFactory() {    
            initialBossHP = scoreboard.getBossHP();
        }
        
        // this should get the enterFrame tick like everything else
        override public function update():void {
			if(spawnCount < spawnMax) { // if we haven't exhausted all our dudes
				if(actionCounter >= spawnDelay && enemiesRoster.length < simultaneousSpawnMax) { // and we've waited long enough between spawns
					if(pitcherCount < simultaneousPitcherMax) { // if we don't have any pitchers spawned
						currentEnemy = new EnemyPitcher(); // then spawn one
						pitcherCount++; // and increment our pitcher count
					} else { // otherwise
						currentEnemy = new EnemyBlacksox(); // spawn a batter
					}
					//currentEnemy.addObserver(this); // subscribe to its updates
					enemiesRoster.push(currentEnemy); // and add it to our roster
					myMap.spawnActor(currentEnemy, this.x, this.y); // and finally spawn it on the map
					if(this.x > 256) { // if it's on the right side of the map
						currentEnemy.reverseDirection(); // send it off towards our hero
					}

					actionCounter = 0; // reset our action counter
					spawnCount++; // and increment our spawn count
				} else { // otherwise, if we haven't waited long enough
					actionCounter++; // increment our frame counter
				}
			} else { // otherwise if we've sent out all our baddies
				if(enemiesRoster.length == 0) { // and we don't have any live ones
					notifyObservers(); // let everybody know
				}
			}
        }

		override public function notify(subject:*):void {
		    if(subject is EnemyBlacksox || subject is EnemyPitcher) { // if it's one of our enemies
				if(isMine(subject)) {
					if(subject.getHP() <= 0) { // and it's dead
						subject.removeObserver(this); // then unsubscribe from it
						removeEnemy(subject); // remove it from our current roster
						deathCount++;
						if(deathCount % 2) {
						    scoreboard.setBossHP(scoreboard.getBossHP() - 1);
						    trace("healthDown " + scoreboard.getBossHP());
						} else {
						    trace("spawnCount = " + spawnCount);
						}
						if(subject is EnemyPitcher) { // and if it's a pitcher
							pitcherCount--; // adjust our pitcher count accordingly
						}
					}
				}
			}
		}
		
		private function isMine(subject:*) {
			for (var ob:int=0; ob<enemiesRoster.length; ob++) { // loop through all of our enemies
                if(enemiesRoster[ob] == subject) { // and if we find this one
					return true;
				}
			}
			return false;
		}
		
		public function removeEnemy(enemy):void {
		    for (var ob:int=0; ob<enemiesRoster.length; ob++) { // loop through all of our enemies
                if(enemiesRoster[ob] == enemy) { // and if we find this one
                    enemiesRoster.splice(ob,1); // get rid of that noise
                    break; // and break this vicious cycle
                }
            }
		}
        
    }
    
}