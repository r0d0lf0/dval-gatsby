package assets {
    
    import engine.assets.*;
    
 
   // Levels are any GameAsset that uses a Hero to guide its li
   public class StartScreen extends Asset implements IGameAsset {
       
       public function StartScreen(ldr) {
           super(ldr);
       }
       
       override public function update():Boolean {
           return true;
       }
       
       override public function getStatus():String {
           return status;
       }
   }
}