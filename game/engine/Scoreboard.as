package engine{
    
    // Scoreboard, not sure what this is gonna do yet
    public class Scoreboard {
        
        private var score:Number = 0;
        private var hero_lives:Number = 3;
        
        public function Scoreboard() {
            
            trace("Scoreboard created.");
            
        }
        
        public function getScore():Number {
            return score;
        }
        
        public function getHeroLives():Number {
            return hero_lives;
        }
        
        public function killHero():void {
            hero_lives--;
        }
        
        public function addToScore(points:Number):void {
            score += points;
        }
        
    }
}