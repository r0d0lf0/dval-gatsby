package engine.actors {
    
    import engine.actors.Actor;
    import engine.IKeyboard;
    import flash.ui.Keyboard;
    import controls.KeyMap;
    import flash.text.TextField;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import engine.Scoreboard
    
    // Generic class for a MapObject that is able to be animatable.  MapObject should be the first class, this second, then different
    // moving blocks/aes/baddies should extend this.
    //
    // this will give animation methods to actors, so with basic commands like animate(start, end, loop/bounce/plannstop)
    
    public class DialogBox extends Actor implements IKeyboard {
        
        public var BUTTON_SHIFT = false;
        public var BUTTON_SPACE = false;
        
        private var messageArray = new Array();
        private var letterDelay = 0;
        private var currentMessage = 0;
        private var frameCounter = 0;
        private var textCounter = 0;
        private var myMessage = "Default message";
        private var typingFlag = false;

	private var keys:KeyMap = KeyMap.getInstance();
	private var keyboardStatus:Array = new Array();
        
	private var scoreboard = Scoreboard.getInstance();

        public const CONTINUE = 1;
        public const EXIT = 2;
        public var exitFunction = CONTINUE;
        
        private var DialogBoxSound = new dialog_box_sound();
        private var DownArrow:down_arrow = new down_arrow();
        private var effectsChannel = new SoundChannel();
        
        public function DialogBox() {    
            // set up our down arrow blinking dealie
            textArea.text = "";
            var blinkTimer:Timer = new Timer(500);
            blinkTimer.addEventListener(TimerEvent.TIMER, blinkArrow);
	    
            blinkTimer.start();
            addChild(DownArrow);
            DownArrow.x = 226;
            DownArrow.y = 52;
        }
        
        public function setExitFunction(exitFunction) {
            this.exitFunction = exitFunction;
        }
        
        public function setText(messageArray:Array) {
            this.messageArray = messageArray;
        }
        
        public function typeText() {
            textCounter = 0;
            textArea.text = "";
            effectsChannel = DialogBoxSound.play(0, 50);
            this.alpha = 1;
            typingFlag = true;
        }
        
        public function start() {
            // here's where we start the dialog box
            this.alpha = 1;
	    scoreboard.stopTimer();
            typingFlag = true;
        }
        
        public function blinkArrow(event:TimerEvent) {
            if(DownArrow.alpha) {
                DownArrow.alpha = 0;
            } else {
                DownArrow.alpha = 1;
            }
        }
        
        public function keyUpHandler(evt):void {
	    if(evt.keyCode == Keyboard.SHIFT || evt.keyCode == Keyboard.SPACE) {
		BUTTON_SHIFT = false;
	    }
	}
	
	public function keyDownHandler(evt):void {
	    if(evt.keyCode == Keyboard.SHIFT || evt.keyCode == Keyboard.SPACE) { // if someone's hitting enter anew
		BUTTON_SHIFT = true; // mark our holder as pressed
	    }
	}
        
        // this should get the enterFrame tick like everything else
        override public function update():void {            
	    if(BUTTON_SHIFT) {
		if(typingFlag) { // if we're typing and arent' at teh end yet
    	            textCounter = messageArray[currentMessage].length; // jump to the end of the message
    	        } else if(currentMessage < (messageArray.length - 1)) { // otherwise, if there are more messages
    	            currentMessage++; // get the next message
    	            typeText(); // and start typing
    	        } else { // if we're not typing, and we're at the last message
    	            if(exitFunction == CONTINUE) {
    	                myMap.unPauseMap(this); // unpause the game
    	            } else if(exitFunction == EXIT) {
    	                myMap.unPauseMap(this);
			scoreboard.startTimer();
    	                myMap.updateStatus(COMPLETE);
    	            } 
    	        }
    	        BUTTON_SHIFT = false;
	    }

            
            if(typingFlag) { // if we're typing
                if(frameCounter >= letterDelay) { // and we're on the right frame
                    if(textArea.text.length < messageArray[currentMessage].length) { // and we have typed less than the length of our message
                        textArea.text = messageArray[currentMessage].substr(0, textCounter); // then set our text to our length
                        textCounter++; // and increment our text counter
                    } else { // otherwise we're doing typing
                        typingFlag = false; // so reset our typing flag
                    }
                    frameCounter = 0;
                } else {
                    frameCounter++;
                }   
            } else {
                effectsChannel.stop();
            }
        }
        
    }
    
}