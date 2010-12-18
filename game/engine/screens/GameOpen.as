package engine.screens{

    import flash.display.*;
	import engine.Map;
	import flash.events.*;
	import flash.events.MouseEvent;
	import engine.Screen; 
	import flash.utils.getDefinitionByName;
	import engine.IKeyboard;
	import flash.ui.Keyboard;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	
	public class GameOpen extends Screen implements IKeyboard {

		private var music:gold_hat;
		private var start_sound:press_start_sound;
	    private var musicChannel:SoundChannel;
	    
	    private var counter:Number = 0;
	
		private var timerFlag = false;
	
		private var background_tile:Shape;
		private var background_coney;
		private var eyesArray = new Array();
		private var eyesCounter = 0;
		private var titleArray = new Array();
		private var titleCounter = 0;
		
		private var interlaceCounter = 0;
				
		private var actionCounter = 0;
		
		private static var BUTTON_ENTER = false;
		
		private var prevAction = 0;
		
		protected var keyMaster; // holding variable for our keyboard controller
		protected var prevKeyMaster; // holding var for previous keyboard master
		protected var newKeyMaster; // holder for new keymaster
	
	    public function GameOpen() {
        	if (stage != null) {
				myInit();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			myInit();
		}
		
		private function myInit() {		
			// get everything we need from the library
			background_coney = getMovieFromLibrary("background_coney");
			
			eyesArray.push(getMovieFromLibrary("eyes_half"));
			eyesArray.push(getMovieFromLibrary("eyes_full"));
			
			titleArray.push(getMovieFromLibrary("title_half"));
			titleArray.push(getMovieFromLibrary("title_full"));
			
			trace("GameOpen opened.");
	        updateStatus(ACTIVE);
			
			background_tile = new Shape;
			background_tile.graphics.beginFill(0x0000FC);
			background_tile.graphics.drawRect(0, 0, 256, 240);
			background_tile.graphics.endFill();
			this.addChild(background_tile);
			
			// setup our coney background
			background_coney.y = 147;
			this.addChild(background_coney);
			
			//  grab our keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
	        stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
			
			// setup our array of eyes frames
			//var eyes1 = new 
			
			var myTimer:Timer = new Timer(1000,1);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);

			function timerListener (e:TimerEvent):void{
				
			}

			function timerDone(e:TimerEvent):void{
				actionCounter++;
			}
	    }
	
		private function getMovieFromLibrary(mcIName:String){
			var tMC:Class = getDefinitionByName(mcIName) as Class;
			var newMc:MovieClip = new tMC() as MovieClip;
			return newMc;
		}
		
		public function keyDownHandler(evt):void {
		    // here's where we handle keyboard changes
		    if(evt.keyCode == Keyboard.ENTER || evt.keyCode == Keyboard.SPACE) {
		        BUTTON_ENTER = true;
				prevAction = actionCounter;
				actionCounter = 99;
		    }
		}
		
		public function keyUpHandler(evt):void {
		    // here's where we handle keyboard changes
		    if(evt.keyCode == Keyboard.ENTER) {
		        BUTTON_ENTER = false;
		    }
		}
	
		private function startMusic() {
		    music = new gold_hat();  // create an instance of the music
		    musicChannel = music.play(0, 100);  // play it, looping 100 times
//		    myTransform = new SoundTransform(.35, 0);
//		    musicChannel.soundTransform = myTransform;
		}
		
		private function stopMusic() {
		    if(musicChannel) {
		        musicChannel.stop();
		    }
		}
	    
	    override public function update(evt = null):Boolean{
			interlaceCounter++;
			var myTimer = new Timer(2000,1);
			
			eyesArray[0].alpha = interlaceCounter % 2;
			titleArray[0].alpha = interlaceCounter % 2;
			
			function timerListener (e:TimerEvent):void{

			}

			function timerDone(e:TimerEvent):void{
					actionCounter++;
					timerFlag = false;
			}
		
			if(!timerFlag || BUTTON_ENTER) {
				if(actionCounter == 1) {
					if(background_coney.y > 0) {
						background_coney.y -= 1;
					}
					if(background_coney.y <= 0) {
						background_coney.y = 0;
						myTimer = new Timer(1000,1);
						myTimer.addEventListener(TimerEvent.TIMER, timerListener);
						myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
						myTimer.start(); // actionCounter 3
						timerFlag = true;
					}
				} else if(actionCounter == 2) {

					startMusic();

					myTimer = new Timer(2000,1);
					myTimer.addEventListener(TimerEvent.TIMER, timerListener);
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					myTimer.start(); // actionCounter 3


					timerFlag = true;
				} else if(actionCounter == 3) {
					eyesArray[0].x = 8;
					eyesArray[0].y = 80;
					this.addChild(eyesArray[0]);
					timerFlag = true; // let the timer pick this next one up
					myTimer = new Timer(1000,1);
					myTimer.addEventListener(TimerEvent.TIMER, timerListener);
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					myTimer.start(); // actionCounter 3
				} else if(actionCounter == 4) {
					eyesArray[1].x = 8;
					eyesArray[1].y = 80;
					this.addChild(eyesArray[1]);
					timerFlag = true; // let the timer pick this next one up
					myTimer = new Timer(1000,1);
					myTimer.addEventListener(TimerEvent.TIMER, timerListener);
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					myTimer.start(); // actionCounter 3
				} else if(actionCounter == 5) {
					titleArray[0].x = 40;
					titleArray[0].y = 8;
					this.addChild(titleArray[0]);
					timerFlag = true;
					myTimer = new Timer(500,1);
					myTimer.addEventListener(TimerEvent.TIMER, timerListener);
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					myTimer.start(); // actionCounter 3
				} else if(actionCounter == 6) {
					titleArray[1].x = 40;
					titleArray[1].y = 8;
					this.addChild(titleArray[1]);
					timerFlag = true;
					myTimer = new Timer(1000,1);
					myTimer.addEventListener(TimerEvent.TIMER, timerListener);
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					myTimer.start(); // actionCounter 3
				} else if(actionCounter == 7) {
					PressStart.x = 80;
					PressStart.y = 120;
					setChildIndex(PressStart,numChildren - 1);
					actionCounter++;
					timerFlag = true;
				} else if(actionCounter == 99) {
					BUTTON_ENTER = false;
					if(prevAction < 2) { // coney's not in place yet
						background_coney.y = 0; // move it to the top
						startMusic();
					}
					if(prevAction < 3) {
						eyesArray[0].x = 8;
						eyesArray[0].y = 80;
						this.addChild(eyesArray[0]);
					}
					if(prevAction < 4) {
						eyesArray[1].x = 8;
						eyesArray[1].y = 80;
						this.addChild(eyesArray[1]);
					}
					if(prevAction < 5) {
						titleArray[0].x = 40;
						titleArray[0].y = 8;
						this.addChild(titleArray[0]);
					}
					if(prevAction < 6) {
						titleArray[1].x = 40;
						titleArray[1].y = 8;
						this.addChild(titleArray[1]);
					}
					if(prevAction < 7) {
						PressStart.x = 80;
						PressStart.y = 120;
						setChildIndex(PressStart,numChildren - 1);
					}
					if(prevAction == 99 || prevAction == 8) {
						stopMusic();
						start_sound = new press_start_sound();  // create an instance of the music
						musicChannel = start_sound.play(0, 0);  // play it, looping 100 times
						myTimer = new Timer(200,12);
						function endTimerListener() {
							actionCounter++;
							PressStart.alpha = actionCounter % 2;
						}
						
						function endTimerDone() {
							updateStatus(COMPLETE);
							trace("complete!");
						}
						myTimer.addEventListener(TimerEvent.TIMER, endTimerListener);
						myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endTimerDone);
						myTimer.start(); // actionCounter 3
					}
					timerFlag = true;
				}
				trace(actionCounter);
			}
			if(getStatus() != COMPLETE) {
				return true;
			} else {
				return false;
			}
			
		}
	}
}