package engine{

    import flash.display.MovieClip;
    import flash.text.*;
    
    // Scoreboard, not sure what this is gonna do yet
    public class Scoreboard extends MovieClip {
        
        private var my_score = 0;
        private var hero_lives = 3;

        public function Scoreboard() {
            trace("Scoreboard created.");
            
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
        
    }
}