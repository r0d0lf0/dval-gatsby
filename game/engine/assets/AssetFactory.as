package engine.assets {
    
    import assets.*;
    import engine.*;
    import engine.actors.Hero;
    
    // a little factory class for creating all of our assets
    public class AssetFactory {
        
        private var game:NewGame;
        private var hero:Hero;
        
        public function AssetFactory(game:NewGame, hero:Hero) {
            this.game = game;
            this.hero = hero;
            trace("AssetFactory created.");
            
        }
        
        public function createAsset(asset_name:String) {
            
            switch(asset_name) {
                
                case 'level_1':
                    return new Level1(hero);
                
            }
            
        }
        
    }
    
}