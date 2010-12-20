package engine.screens{

    import flash.display.*;
	import engine.Map;
	import flash.events.*;
	import flash.events.MouseEvent;
	import engine.Screen; 
	import flash.utils.getDefinitionByName;
	import engine.IKeyboard;
	import flash.ui.Keyboard;
    import engine.actors.specials.EndingFadeout;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import flash.utils.Timer;
    import flash.events.*;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	
	public class GameEnding extends Screen implements IKeyboard {

        private var frameCounter = 0;

		private var music1:gold_hat_requiem_music = new gold_hat_requiem_music();
		private var music2:credits_music = new credits_music();
		private var start_sound:press_start_sound;
		private var castle_sound:castle_crumble_sound;
	    private var musicChannel:SoundChannel;
	    
	    private var ending_background, ending_castle_foreground, ending_castle_background, credits_text;
	    
	    private var counter:Number = 0;
	
		private var timerFlag = false;
		
		private var interlaceCounter = 0;
				
		private var actionCounter = 0;
		
		private var castleCounter = 0;
		private var castleFinished = false;
		
		private static var BUTTON_ENTER = false;
		
		private var fadeOutCounter = 0;
		private var fadeOutDuration = 30;
		private var fadeOutFinished = false;
		
		private var creditsFinished = false;
		
		private var prevAction = 0;
		
		protected var keyMaster; // holding variable for our keyboard controller
		protected var prevKeyMaster; // holding var for previous keyboard master
		protected var newKeyMaster; // holder for new keymaster
	
	    public function GameEnding() {
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
			trace("GameOpen opened.");
			ending_castle_background = getChildByName('ending_castle_background');
			ending_castle_foreground = getChildByName('ending_castle_foreground');
			ending_background = getChildByName('ending_fadeout');
			credits_text = getChildByName("credits_text");
			credits_text.height = 8000;
			//credits_text.htmlText = "And as I sat there brooding on the old, unknown world, I thought of Gatsby's wonder when he first picked out the green light at the end of Daisy's dock. He had come a long way to this blue lawn, and his dream must have seemed so close that he could hardly fail to grasp it. He did not know that it was already behind him, somewhere back in that vast obscurity beyond the city, where the dark fields of the republic rolled on under the night.";
 			credits_text.htmlText = "GATSBY BELIEVED IN THE GREEN LIGHT, THE ORGASTIC FUTURE THAT YEAR BY YEAR RECEDES BEFORE US. IT ELUDED US THEN, BUT THAT'S NO MATTER -- TOMORROW WE WILL RUN FASTER, STRETCH OUT OUR ARMS FARTHER... AND ONE FINE MORNING --";
            credits_text.htmlText += "<br /><br /><br /><br />SO WE BEAT ON, BOATS AGAINST THE CURRENT, BORNE BACK CEASELESSLY INTO THE PAST.";
            credits_text.htmlText += "<br /><br />CONGRATURATION!";
            credits_text.htmlText += "<br /><br /><br /><br /><br /><br /><br /><br /><br />";
            credits_text.htmlText += "<br /><br />CREATED BY:<br />CHARLIE HOEY &<br />PETER SMITH";
            credits_text.htmlText += "<br /><br />PROGRAMMED BY:<br />CHARLIE HOEY &<br />DYLAN VALENTINE";
            credits_text.htmlText += "<br /><br />MUSIC & ARTWORK BY:<br />PETER SMITH";
            credits_text.htmlText += "<br /><br />BETA TEST TEAM:<BR />JULIA ROSE ROBERTS<BR />MARC ALLAN GOODMAN<BR />ELIZABETH HOEY<BR />JULE MAURER<br />MOLLY KLEINMAN";
            credits_text.htmlText += "<br /><br />BASED ON THE NOVEL BY<br />F. SCOTT FITZGERALD";
            credits_text.htmlText += "<br /><br /><br /><a href='http://goo.gl/A7MTE'>DOWNLOAD THE SOURCE!</a>";
            
	        updateStatus(ACTIVE);
	        pause(2000);
	

            castle_sound = new castle_crumble_sound();
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
		    musicChannel = music1.play(0);  // play it once
            musicChannel.addEventListener(Event.SOUND_COMPLETE, this.soundComplete); // let us know when you're done
            //		    myTransform = new SoundTransform(.35, 0);
            //		    musicChannel.soundTransform = myTransform;
		}
		
		private function stopMusic() {
		    if(musicChannel) {
		        musicChannel.stop();
		    }
		}
		
		public function soundComplete(e) {
		    musicChannel = music2.play(0);
		    musicChannel.removeEventListener(Event.SOUND_COMPLETE, this.soundComplete);
		}
	    
	    override public function update(evt = null):Boolean{
	        if(!pausedFlag) {
	            frameCounter++;
	            
	            if(castleFinished == false) {
	                
	                if(frameCounter == 1) { 
    	                musicChannel = castle_sound.play(0);
    	            }

    	            if(ending_castle_background.y < 101) {
        	            castleCounter++;
        	            ending_castle_background.y = 80 + Math.floor(castleCounter / 5);

        	        } else {
        	            castleFinished = true;
        	            frameCounter = 0;
        	            ending_castle_background.alpha = 0;
        	            ending_castle_foreground.alpha = 0;
        	            pause(2000);
        	        }
	            } else if(fadeOutFinished == false) {
            
	                fadeOutCounter++;
	                if(fadeOutCounter < fadeOutDuration) {
	                    ending_background.setLoop(Math.floor(fadeOutCounter / 7.5), 0, 0, 0, 0);
	                } else {
	                    ending_background.alpha = 0;
	                    fadeOutFinished = true;
    	                startMusic();
	                    pause(2000);
	                }
	            } else if(creditsFinished == false) {
	                credits_text.y = 212 - Math.floor(frameCounter / 4);
	            }
	            

    	        
    	        
    	        
    	        
    	        
	        }

	        
	        
	        
			if(getStatus() != COMPLETE) {
				return true;
			} else {
				return false;
			}
			
		}
	}
}