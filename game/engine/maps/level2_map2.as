package engine.maps {
    
    import engine.Map;
    import engine.actors.background.*;
    import engine.actors.player.Hero;
    import engine.actors.specials.Door;
    
    public class level2_map2 extends Map {
        
        private const fadeLevels = 6;
        private var currentFadeLevel = 0;
        private var fadeSpeed = 15;
        private var fadeCounter = 0;
        private var fadeEnabled = true;
        
        private var boss = new EnemyBossTJEckleberg();
        private var bossEnabled = false;
        private var babyBoss = new baby_eckleberg();
        private var babyBossEnabled = false;
        private var babyBossFly = false;
        private var babyBossCounter = 0;
        private var babyBossDelay = 150;
        private var babyBossVelY = 5;
        
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
                    if(currentFadeLevel == 5) {
                        fadeSpeed = 60;
                    }
                    if(currentFadeLevel > fadeLevels) {
                        currentFadeLevel = 0;
                        removeFromMap(skyPlane);
                        removeFromMap(treePlane);
                        babyBoss.x = 176;
                        babyBoss.y = 32;
                        babyBoss.alpha = 0;
                        babyBossEnabled = true;
                        addChild(babyBoss);
                        fadeEnabled = false;
                    }
                    skyPlane.setLoop(currentFadeLevel, 0, 0, 0, 0);
                    treePlane.setLoop(currentFadeLevel, 0, 0, 0, 0);
                }   
            } else if(babyBossEnabled) {
                if(babyBossCounter < babyBossDelay) {
                    babyBossCounter++;
                    if(babyBossCounter < 60 && babyBossCounter > 50) {
                        babyBoss.alpha = (babyBossCounter % 4 == 1);
                    } else if(babyBossCounter > 60 && babyBossCounter < 110) {
                        babyBoss.alpha = babyBossCounter % 2;
                    } else if(babyBossCounter >= 110) {
                        babyBoss.alpha = 1;
                    }
                } else {
                    babyBossFly = true;
                    babyBossEnabled = false;
                }
            } else if(babyBossFly) {
                babyBossVelY -= 1;
                if(babyBossVelY < -8) {
                    babyBossVelY = -8;
                }
                babyBoss.y += babyBossVelY;
                if(babyBoss.y < -200) {
                    babyBossFly = false;
                    spawnActor(boss, 64, -70);
                    setChildIndex(boss,0);
                    scoreboard.startTimer();
                }
            }
		}
		
		private function moveSky() {
		    skyCounter += skySpeed;
		    if(skyCounter >= skyLoop) {
		        skyCounter = skyLoop - skyCounter;
		    }
		    skyPlane.x = -skyCounter;
		}
		
		private function moveTrees() {
		    treeCounter += treeSpeed;
		    if(treeCounter >= treeLoop) {
		        treeCounter = treeLoop - treeCounter;
		    }
		    treePlane.x = -treeCounter
		}
		
		override public function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
		    heroHP = scoreboard.getHeroHP();
		    skyPlane.followHero = false;
		    treePlane.followHero = false;
		    spawnActor(skyPlane);
		    spawnActor(treePlane);
		    scoreboard.stopTimer();
		    treePlane.y = 48;
		    setChildIndex(skyPlane,0);
		    setChildIndex(treePlane,0);
    		updateSubscriptions();
    		updateStatus(ACTIVE);
    		prevStatus = ACTIVE;
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		override public function notify(subject:*):void {
		    if(subject is Hero) {
		        moveMap(subject);
		        if(heroHP != scoreboard.getHeroHP()) { // if our hero's HP has changed
		            heroHP = scoreboard.getHeroHP(); // reset our holder for HP
		            notifyObservers(); // and tell the level about it
		        }
		    }
		}
        
    }
    
}
