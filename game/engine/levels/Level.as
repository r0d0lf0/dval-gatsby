package engine.levels {
    
    public class Level {
        
        private var name:String = "Unnamed Level";
        private var map:Map;
        private var clock:Number;
        
        public function Level(map:Map, hero:Hero) {
            this.map = map;
            this.map.addHero(hero);
            trace("Level Created.");
        }
        
        public function startLevel() {
            
        }
        
    }
    
}