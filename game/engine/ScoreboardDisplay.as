package engine{

    import flash.display.MovieClip;
    import flash.text.TextField;
    import engine.IObserver;
    import engine.Scoreboard;
    
    // ScoreboardDisplay is the visual representation of the scoreboard, vs Scoreboard, which actually holds the data
    public class ScoreboardDisplay extends MovieClip implements IObserver {
        
        public var my_score = 0;
        public var hero_lives = 3;
        private var scoreboard:Scoreboard;

        public function ScoreboardDisplay() {
            trace("ScoreboardDisplay created.");
            scoreboard = Scoreboard.getInstance();
            setHealth(scoreboard.getHP());
            setLives(scoreboard.getLives());
            setScore(scoreboard.getScore());
        }
        
        public function removeLife():void {
            hero_lives--;
        }
        
        public function addLife():void {
            hero_lives++;
        }

        public function setScore(score:Number):void {
            my_score = score;
            var score_text = my_score.toString();
            while(score_text.length < 8) {
                score_text = '0' + score_text;
            }
            display_score.text = 'SCORE: ' + score_text;
        }
        
        public function setHealth(health:Number):void {
            switch(health) {
                case 0:
                    health1.alpha = 0;
                    health2.alpha = 0;
                    health3.alpha = 0;
                    break;
                case 1:
                    health1.alpha = 100;
                    health2.alpha = 0;
                    health3.alpha = 0;
                    break;
                case 2:
                    health1.alpha = 100;
                    health2.alpha = 100;
                    health3.alpha = 0; 
                    break;
                case 3:
                    health1.alpha = 100;
                    health2.alpha = 100;
                    health3.alpha = 100;
                    break;
            }
        }
        
        public function setLives(lives:Number) {
            for(var i=0;i<lives;i++) {
                var lifeIcon = new LifeIcon();
                addChild(lifeIcon);
                lifeIcon.y = 16;
                lifeIcon.x = 250 - (10 * i);
            }
        }
        
        public function notify(subject:*):void {
            setHealth(scoreboard.getHP());
            setScore(scoreboard.getScore());
            setLives(scoreboard.getLives());
            trace("Lives " + scoreboard.getLives());
        }
        
    }
}