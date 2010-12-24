package engine.screens{

    import flash.display.MovieClip;
    import flash.display.Bitmap;
	import engine.Map;
	import flash.events.MouseEvent;
	import engine.Screen;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
    import engine.IKeyboard;
    import flash.ui.Keyboard;
	import controls.KeyMap;	
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import utils.FlipTimer;
	
	public dynamic class CutScene2 extends Screen {
	    
	    private var my_counter:Number = 0;
	    private var my_shirt_counter = 0;
	    private var daisy_counter = 0;
	    private var gatsby_counter = 0;
		private var total_frames:Number = 500;
		private var childMovie;
		private var movieLoaded = false;
	    private var killFlag = false;
	    private var BUTTON_SHIFT = false;
	    private var mLoader;
	    private var music = new cutscene2_music();
	    private var throw_sound = new shirt_throw_sound();
	    private var soundChannel;
	    private var musicChannel;
	    
	    private var throwVel = -4;
	    private var velx = 3;
	    private var vely = throwVel;
	    private var shirtPosX = 0;
	    private var shirtPosY = 0;
	    private var shirtVelMax = 2;

	    private var shirtsArray = new Array();
	    
	    public var green_background;
	    public var frame;
	    
	    private var daisy;
	    private var gatsby;
	    private var gatsbyMove = false;
	    
	    public var movieOver = false;
	    private var keyboardAdded = false;
	    
	    
	    public function CutScene2() {
			startLoad();	
	    }
	    
	    public function keyUpHandler(evt):void {
		    if(evt.keyCode == Keyboard.SHIFT) {
		        BUTTON_SHIFT = false;
		    }
		}
		
		public function keyDownHandler(evt):void {
		    if(evt.keyCode == Keyboard.SHIFT && BUTTON_SHIFT == false) { // if someone's hitting enter anew
                killFlag = true;
                BUTTON_SHIFT = true;
                movieOver = true;
		    }
		}
	
		public function startLoad()
		{
		    
            green_background = new Bitmap(new cutscene2_background(0, 0));
            green_background.x = 68;
            green_background.y = 70;
            addChild(green_background);
            
            shirtsArray.push(new Bitmap(new shirt1(0, 0)));
            shirtsArray.push(new Bitmap(new shirt2(0, 0)));
            shirtsArray.push(new Bitmap(new shirt3(0, 0)));
            shirtsArray.push(new Bitmap(new shirt4(0, 0)));
            
            for(var i = 0; i < shirtsArray.length; i++) {
                shirtPosX = 32;
        	    shirtPosY = 128;
                shirtsArray[i].x = shirtPosX;
                shirtsArray[i].y = shirtPosY;

                addChild(shirtsArray[i]);
            }
            
            gatsby = new Bitmap(new cutscene2_gatsby(0, 0));
            gatsby.x = 0;
            gatsby.y = 72;
            addChild(gatsby);
            
            daisy = new Cutscene2_Daisy();
            daisy.y = 272;
            daisy.x = 112;
            addChild(daisy);
            
            frame = new Bitmap(new cutscene_frame(0, 0));
            addChild(frame);
            
            musicChannel = music.play(0);
		}
		
		public function cutsceneOver() {
		    movieOver = true;
		}
	
	    override public function update(evt = null):Boolean{
	        my_counter++;
	        
	        if(!keyboardAdded) {
	            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
    	        stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
    	        keyboardAdded = true;
	        }
	        
	        if(Math.floor(my_counter / 5) >= 1) {
	            if(green_background.y > -40) {
    	            green_background.y--;
    	        }
    	        my_counter = 0
	        } 
	        
	        my_shirt_counter++;
	        if(Math.floor(my_shirt_counter / 2) >= 1) {
	            for(var i = 0; i < shirtsArray.length; i++) {
    	            if(shirtsArray[i].y < 220) {
    	                if(shirtPosX == 32) {
    	                    soundChannel = throw_sound.play(0);
    	                }
    	                vely += .25;
    	                if(vely > shirtVelMax) {
    	                    vely = shirtVelMax;
    	                }
    	                shirtPosY += vely;
    	                shirtPosX += velx;

    	                shirtsArray[i].x = Math.floor(shirtPosX);
    	                shirtsArray[i].y = Math.floor(shirtPosY);
    	                break;
    	            } else {
    	                removeChild(shirtsArray[i]);
                        shirtsArray.splice(i,1);
                        vely = throwVel;
                        shirtPosX = 32;
                        shirtPosY = 128;
    	            }
    	        }
    	        my_shirt_counter = 0;
	        }
	        
	        daisy_counter++;
	        if(green_background.y < 0 && daisy.y > 74) {
	            if(Math.floor(daisy_counter / 2) >= 1) {
	                daisy.y--;
	                daisy_counter = 0;
	            }
	        }
	        daisy.update();
	        
	        if(daisy.y <= 74) {
	            if(gatsby.x < 64) {
	                gatsby_counter++;
	                if(Math.floor(gatsby_counter / 2) >= 1) {
    	                gatsby.x++;
    	                gatsby_counter = 0;
    	            }
	            } else {
	                new FlipTimer(this, "cutsceneOver", 2000);
	            }
	        }
	        
	        if(movieOver) {
	            SoundMixer.stopAll();
	            updateStatus(COMPLETE);
	            return false;
	        } else {
	            return true;
	        }
	        
        }
	    
	}
}