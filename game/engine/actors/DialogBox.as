package engine.actors {
    
    import engine.actors.Actor;
    import flash.text.TextField;
    import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    
    // Generic class for a MapObject that is able to be animatable.  MapObject should be the first class, this second, then different
    // moving blocks/aes/baddies should extend this.
    //
    // this will give animation methods to actors, so with basic commands like animate(start, end, loop/bounce/plannstop)
    
    public class DialogBox extends Actor {
        
        private var messageArray = new Array();
        private var letterDelay = 1;
        private var currentMessage = 0;
        private var frameCounter = 0;
        private var textCounter = 0;
        private var myMessage = "Default message";
        private var typingFlag = false;
        
        private var DialogBoxSound = new dialog_box_sound();
        private var DownArrow:down_arrow = new down_arrow();
        private var effectsChannel;
        
        public function DialogBox() {
            textArea.text = " ";
            
            // set up our down arrow blinking dealie
            var blinkTimer:Timer = new Timer(500);
            blinkTimer.addEventListener(TimerEvent.TIMER, blinkArrow);
            blinkTimer.start();
            addChild(DownArrow);
            DownArrow.x = 226;
            DownArrow.y = 52;
        }
        
        public function setText(newText) {
            myMessage = newText;
            textArea.text = " ";
            typingFlag = false;
        }
        
        public function typeText() {
            typingFlag = true;
            effectsChannel = DialogBoxSound.play(0, 100);
        }
        
        public function start() {
            // here's where we start the dialog box
            this.alpha = 1;
            typingFlag = true;
        }
        
        public function blinkArrow(event:TimerEvent) {
            if(DownArrow.alpha) {
                DownArrow.alpha = 0;
            } else {
                DownArrow.alpha = 1;
            }
        }
        
        // this should get the enterFrame tick like everything else
        override public function update():void {
            if(typingFlag) {
                if(frameCounter >= letterDelay) {
                    if(textArea.text.length < messageArray[currentMessage].length) {
                        textArea.text = messageArray[currentMessage].substr(0, textCounter);
                    } else {
                        effectsChannel.stop();
                    }
                    frameCounter = 0;
                    textCounter++;
                } else {
                    frameCounter++;
                }   
            }
        }
        
    }
    
}