package engine.assets {
    
    // GameAssets get plugged into the onEnterFrame action, and return their status to the Game
    public interface IGameAsset {
        
        function update():Boolean;
        
        function getStatus():String;
        
    }
    
}