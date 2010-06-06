package engine{
    
    // Scoreboard, not sure what this is gonna do yet
    public class Scoreboard {
        
        private var score = 1000;
        
        public function Scoreboard() {
            
            trace("Scoreboard created.");
            
        }
        
        public function getScore():Number {
            return score;
        }
        
    }
}