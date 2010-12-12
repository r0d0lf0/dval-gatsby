package engine{

    import flash.display.MovieClip;
    import flash.text.TextField;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.HealthBar;
    
    // ScoreboardDisplay is the visual representation of the scoreboard, vs Scoreboard, which actually holds the data
    public class ScoreboardDisplay extends MovieClip implements IObserver {
        
        public var my_score = 0;
        public var hero_lives = 3;
        private var scoreboard:Scoreboard;
        //                   ******************************
        private var line1 = "1UP -  -%l   %c    SCORE %s";      // num lives, coins, score
		private var line2 = "NICK CARRAWAY        STAGE %l-%m"; // level, map
		private var line3 = "%b%pTIME %t";
		private const lineLength = 30;
		
		private var heroHealth, bossHealth;
		
		private var line1Field, line2Field, line3Field;

        public function ScoreboardDisplay() {
            scoreboard = Scoreboard.getInstance();
            line1Field = getChildByName('score_line1');
            line2Field = getChildByName('score_line2');
            line3Field = getChildByName('score_line3');
            
            // setup our hero healthbar
            heroHealth = new HealthBar(3);
            heroHealth.x = 120;
            heroHealth.y = 12;
            addChild(heroHealth);
            
            // setup our boss healthbar
            bossHealth = new HealthBar(5);
            bossHealth.x = 120;
            bossHealth.y = 20;
            addChild(bossHealth);
            
            updateScoreboardDisplay();
        }
        
        private function updateScoreboardDisplay() {
            // build line 1
            var newline1 = line1;
            newline1 = newline1.split('%l').join(scoreboard.getLives());
            newline1 = newline1.split('%c').join(padNum(scoreboard.getCoins(), 2));
            newline1 = newline1.split('%s').join(padNum(scoreboard.getScore(), 6));
            
            // build line 2
            var newline2 = line2;
            newline2 = newline2.split('%l').join(scoreboard.getCurrentLevel());
            newline2 = newline2.split('%m').join(scoreboard.getCurrentMap());
            heroHealth.setHealth(scoreboard.getHeroHP());
            
            // build line 3
            var newline3 = line3;
            newline3 = newline3.split('%b').join(scoreboard.getCurrentBoss());
            newline3 = newline3.split('%t').join(padNum(scoreboard.getCurrentTime(), 3));
            var numSpaces = lineLength - newline3.length;
            var p = "";
            while(p.length - 2 < numSpaces) {
                p += " ";
            }
            newline3 = newline3.split('%p').join(p);
            bossHealth.setHealth(scoreboard.getBossHP());
            
            line1Field.text = newline1;
            line2Field.text = newline2;
            line3Field.text = newline3;
        }

        public function notify(subject:*):void {
            updateScoreboardDisplay();
        }

        private function padNum(stringVar = " ", numSpaces = 0) {
            var myString = stringVar.toString();
            while(myString.length < numSpaces) {
                myString = "0" + myString;
            }
            return myString;
        }
    }
}