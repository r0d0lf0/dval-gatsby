package engine.assetPrototypes {
    
    import assets.*;
    import engine.*;
    import engine.actors.Hero;
    
    // a little factory class for creating all of our assets
    public class AssetFactory {
        
        private var game:NewGame;
        private var hero:Hero;
        private var ldr;
        
        public function AssetFactory(game:NewGame, hero:Hero) {
            this.game = game;
            this.hero = hero;
            trace("AssetFactory created.");
            
        }
        
        public function createAsset(asset_name:String) {
            
            switch(asset_name) {
                
                case 'StartScreen':
                    return new StartScreen(game);
                case 'Level1':
                    return new Level1(game, hero);
                
            }
            
        }
        
    }
    
}