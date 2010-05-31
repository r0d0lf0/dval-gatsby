package engine.levels{
    
    public class MapObjectFactory {
        
        public function MapObjectFactory() {
            trace("MapObjectFactory started.");
        }
        
        public function createMapObject(type:String) {
            switch(type) {
                case 'BLOCK':
                    return new Block();
                case 'CLOUD':
                    return new Cloud();
                case 'DOOR':
                    return new Door();
                case 'HERO':
                    return new Hero();
                case 'WEAPON':
                    return new Weapon();
                default:
                    return false;
            }
        }
    }
}