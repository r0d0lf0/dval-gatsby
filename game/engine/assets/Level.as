package engine.assets {
    
    import engine.assets.IGameAsset;
    import flash.display.MovieClip;
    import engine.*;
	import engine.actors.*;
	import engine.assets.*;
    
 
   // Levels are any GameAsset that uses a Hero to guide its li
   public class Level extends MovieClip implements IGameAsset {
       
       protected var hero:Hero;
       protected var assets:Array;
       protected var map:Map;
       protected var status:String = "just fine";
       protected var count = 0;
       
       public function Level(hero:Hero) {
           this.hero = hero;
           trace("Level created.");
       }
       
       public function getStatus():String {
           return status;
       }
       
       private function killHero() {
           
       }
       
       public function update():Boolean {
           count++;
           if(count > 60) {
               status = "COMPLETE";
               return false;
           } else {
               return true;
           }

       }
       
       private function start():void {
           map = new Map();
           this.addChild(map);
       }
       
       private function run():Boolean {
           return true;
       }
       
       private function complete():Boolean {
           return true;
       }
       
   }
    
}