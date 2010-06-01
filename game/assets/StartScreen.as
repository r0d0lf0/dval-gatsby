package assets {
    
    import controls.KeyMap;
    import engine.assets.*;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
 
   // Levels are any GameAsset that uses a Hero to guide its li
   public class StartScreen extends Asset implements IGameAsset {
       
       var myObjects:Array = new Array();
       var blink_off:Number = 20; // how long should Press Start blink off
       var blink_on:Number = 50; // how long should Press Start blink on
       var current_time:Number = 0;
       var start_button:DisplayObject;

       public function StartScreen(ldr) {
           super(ldr);
           start_button = this.getChildByName('myTitle');
           this.addChild(keys);
		   keys.addEventListener(KeyMap.KEY_DOWN, onKeyPress); // elsewhere later if we need them
       }
       
       private function updateStartButton() {
           current_time++;
           if(start_button.alpha == 0) {
               if(current_time >= blink_off) {
                   start_button.alpha = 100;
                   current_time = 0;
               }
           } else {
               if(current_time >= blink_on) {
                   start_button.alpha = 0;
                   current_time = 0;
               }
           }
       }
       
       override public function update():Boolean {
            // loop through all the child objects attached to this library item, and put
		    // references to them into a local array
		   updateStartButton();
		   if(status != "COMPLETE") {
		       return true;
		   } else {
               return false;		       
		   }

       }
       
       override public function getStatus():String {
           return status;
       }
       
       private function onKeyPress(e) {
           if(keys.getLastKey() == 32) {
               status = "COMPLETE";
           }
       }
       
   }
}