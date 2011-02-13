package engine {
	
    import engine.actors.ActorScore;
    import engine.actors.specials.ScorePowerup;
    import engine.actors.specials.MoneyBag;
    import engine.actors.enemies.Enemy;
    import engine.actors.enemies.EnemyWalker;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
   
    
    public class Scoreboard implements ISubject {
    
        private static var _instance:Scoreboard;
        public static var score:int = 0;
        public static var lives:int = 3;
        public static var heroHP:int = 3;
        public static var heroPowerupMode = "Default";
        public static var bossHP:int = 5;
        public static var coins:int = 0;
	public static var moneyBagHolder:int = 0;
	public static var moneyBags:int = 0;
        public static var currentLevel:int = 0;
        public static var currentMap:int = 0;
        public static var currentBoss = "BOSS NAME";
        public static var timeLimit:int = 300;
        public static var timer:int = timeLimit;
        public static var timerTimer;
        private static var observers:Array = new Array();
	public static var multiplier = 1;
	private static var effectsChannel;
	private static var extraLivesCounter = 0;
	private static const extraLivesCoins = 100;
	private static var deathCount = 0;	
	private static var Hero, Boss;
	private static var get_gold_hat = new get_gold_hat_sound();
	private static var lose_gold_hat = new lose_gold_hat_sound();

	private static var hitSounds = new Array();

        public function Scoreboard(pvt:PrivateClass) {
            timerTimer = new Timer(850);
            timerTimer.addEventListener(TimerEvent.TIMER, this.timerTick);
            startTimer();
	    hitSounds[0] = new hitsound_1();
	    hitSounds[1] = new hitsound_2();
	    hitSounds[2] = new hitsound_3();
	    hitSounds[3] = new hitsound_4();
	    hitSounds[4] = new hitsound_5();
        }
        
        public function startTimer() {
	    timerTimer.start();
        }
        
        public function setHeroPowerupMode(newMode) {
            if(newMode != heroPowerupMode) {
                heroPowerupMode = newMode;
                if(newMode == "Default") {
                    effectsChannel = lose_gold_hat.play(0);
                }
            }
            
        }
        
        public function getHeroPowerupMode() {
            return heroPowerupMode;
        }
        
        public function stopTimer() {
            timerTimer.stop();
        }
        
        public function timerTick(e) {
            timer--;
            if(timer <= 0) {
                setHeroHP(0);
            }
            notifyObservers();
        }
        
        public function timeToPoints() {
            if(timer > 0) {
                timer--;
                Scoreboard.score += 10;
                notifyObservers();
            }
        }
        
        public function setTimeLimit(limit) {
            Scoreboard.timeLimit = limit;
            Scoreboard.timer = limit;
        }
        
        public static function getInstance():Scoreboard {
            if(Scoreboard._instance == null) {
                Scoreboard._instance = new Scoreboard(new PrivateClass());
                trace("Scoreboard instantiated.");
            }
            return Scoreboard._instance;
        }
        
        public function setHeroHP(HP) {
	    if(HP < 0) {
		HP = 0;
	    }
            Scoreboard.heroHP = HP;
            notifyObservers();
        }        
        
        public function getHeroHP():Number {
            return Scoreboard.heroHP;
        }
        
        public function setBossHP(HP) {
            Scoreboard.bossHP = HP;
            notifyObservers();
        }
        
        public function getBossHP():Number {
            return Scoreboard.bossHP;
        }
        
        public function setCurrentBoss(bossName) {
            Scoreboard.currentBoss = bossName;
            notifyObservers();
        }

	public function setMultiplier(newMultiplier) {
	    Scoreboard.multiplier = newMultiplier;
	}
        
        public function addToScore(giver, amount:Number) {
            var additionalAmount = amount * (Math.pow(2, Scoreboard.multiplier - 1));
            Scoreboard.score += additionalAmount;
	    var myScore = new ActorScore(additionalAmount, giver.x, giver.y);
	    var myMap = giver.getMap();
	    myMap.addChild(myScore);
	    if(giver is ScorePowerup) {
		coins++;
		if(checkExtraLife()) {
    		    var myHero = myMap.getHero();
    		    var xtra = new ActorScore('1UP', myHero.x, myHero.y);
    		    myMap.addChild(xtra);
    		    coins = 0;
    		}
	    } else if(giver is MoneyBag) {
		moneyBagHolder++;
	    } else if(giver is Enemy || giver is EnemyWalker) {
		if(Scoreboard.multiplier <= 4) {
		    effectsChannel = hitSounds[Scoreboard.multiplier].play(0);
		} else {
		    effectsChannel = hitSounds[4].play(0);
		}
	    }
            notifyObservers();
        }

	public function clearMoneyBagHolder() {
	    moneyBagHolder = 0;
	}

	public function countMoneyBags() {
	    moneyBags += moneyBagHolder;
	    moneyBagHolder = 0;
	}

	public function getMoneyBagCount():Number {
	    return moneyBags;
	}
        
        public function getCoins():Number {
            return Scoreboard.coins;
        }
        
        public function getCurrentBoss() {
            return Scoreboard.currentBoss;
        }
        
        public function getCurrentTime() {
            return Scoreboard.timer;
        }
        
        public function setCurrentLevel(level) {
            Scoreboard.currentLevel = level;
        }
        
        public function getCurrentLevel():Number {
            return Scoreboard.currentLevel;
        }
        
        public function setCurrentMap(map) {
            Scoreboard.currentMap = map;
        }
        
        public function getCurrentMap():Number {
            return Scoreboard.currentMap;
        }
        
        private function checkExtraLife() {
            if(Scoreboard.coins >= Scoreboard.extraLivesCoins) {
                addLife();
                var xtraLifeSound = new extra_life_sound();
                effectsChannel = xtraLifeSound.play(0);
                return true;
            } else {
                return false;
            }
        }
        
        public function setScore(newScore:Number) {
            Scoreboard.score = newScore;
            notifyObservers();
        }
        
        public function getScore() {
            return Scoreboard.score;
        }
        
        public function addToCoins(amount) {
            coins += amount;
            notifyObservers();
        }
        
        public function removeLife() {
            Scoreboard.lives--;
            Scoreboard.deathCount++;
            notifyObservers();
        }
        
        public function addLife() {
            Scoreboard.lives++;
            notifyObservers();
        }
        
        public function getLives() {
            return Scoreboard.lives;
        }
        
        public function setLives(newLives) {
            Scoreboard.lives = newLives;
        }
        
	public function addObserver(observer):void {
	    if(!isObserver(observer)) {
		observers.push(observer);
	    }
	    notifyObservers();
	}
	
	public function isObserver(observer):Boolean {
	    for(var ob:int=0; ob<observers.length; ob++) {
		if(observers[ob] == observer) {
		    return true;
		}
	    }
	    return false;
	}
	
	public function getDeathCount() {
            return deathCount;
	}
	
	public function removeObserver(observer):void {
	    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1);
                    break;
                }
            }
	}
	
	public function notifyObservers():void {
	    for(var ob=0; ob<observers.length; ob++) {
		observers[ob].notify(this);
	    }
	}
        
    }
    
}

class PrivateClass {
    public function PrivateClass() {
        trace("Private class is up.");
    }
}