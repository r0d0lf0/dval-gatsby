package engine.assetPrototypes {
    
    // GameAssets get plugged into the onEnterFrame action, and return true until they want to exit
    public interface IGameAsset {
        
        function update():Boolean;
        
        function getStatus():String;
        
    }
    
}