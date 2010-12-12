package engine.actors {

    import engine.actors.Actor
    import flash.display.MovieClip;
    import flash.text.TextField;
    import engine.IObserver;
    import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;
    
    // display the boss's health remaining
    public class HealthBar extends Actor {
        
        private var maxHealth = 0;
        private var myHP = 0;
        private var healthBarArray = new Array();
        private const healthBarSpacing = 0;
        private var barReady = false;

        public function HealthBar(mySize = 3) {
            maxHealth = mySize;
            for(var i = 0; i < maxHealth; i++) { // for every HP item
                healthBarArray.push(new HealthIcon()); // add a health bar to our array
                healthBarArray[i].x = (healthBarArray[i].width + healthBarSpacing) * i; // space them out the right amount
                this.addChild(healthBarArray[i]); // and add them to ourselves
            }
            setHealth(maxHealth);
            barReady = true;
        }
        
        private function updateHealth() {
            if(onStage) {
                for(var i = 0; i < maxHealth; i++) { // for each of our health bar icons
                     if(i >= myHP) { // if the boss has less health than this icon's index
                         healthBarArray[i].alpha = 0; // hide it
                     } else { // otherwise
                         healthBarArray[i].alpha = 1; // make sure we can see it
                     }
                 }
            }
        }
        
        public function setHealth(newHP) {
            myHP = newHP;
            updateHealth();
        }
        
        override public function notify(subject:*):void {
            //updateHealth();
        } 
    }
}