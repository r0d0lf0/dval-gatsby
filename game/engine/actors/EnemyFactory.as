package engine.actors {
    
    import engine.actors.Actor;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import engine.actors.enemies.EnemyBlacksox;
    
    public class EnemyFactory extends Actor {
                
		protected var enemySpawned = false;
		protected const spawnMax = 10;
		protected var spawnDelay = 30;
		protected var actionCounter = 0;
		protected var spawnCount = 0;
		protected var currentEnemy;

        public function EnemyFactory() {    

        }
        
        // this should get the enterFrame tick like everything else
        override public function update():void {
			if(spawnCount < spawnMax) {
				if(actionCounter >= spawnDelay) {
					currentEnemy = new EnemyBlacksox();
					myMap.spawnActor(currentEnemy, this.x, this.y);
					if(this.x > 256) {
						currentEnemy.reverseDirection();
					}
					actionCounter = 0;
					spawnDelay = Math.floor(Math.random() * 30) + 15;
					spawnCount++;
				} else {
					actionCounter++;
				}
			/*	if(!enemySpawned) {
					currentEnemy = new EnemyBlacksox();
					myMap.spawnActor(currentEnemy, this.x, this.y);
					if(this.x > 256) {
						currentEnemy.reverseDirection();
					}
					enemySpawned = true;
					spawnCount++;
				} else if(currentEnemy.isRemoved) {
					enemySpawned = false;
				}*/
			}
        }
        
    }
    
}