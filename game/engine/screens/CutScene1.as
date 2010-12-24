package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.MouseEvent;
	import engine.Screen;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.SoundMixer;
	import engine.actors.Actor;
    import engine.IKeyboard;
    import flash.ui.Keyboard;
	import controls.KeyMap;
	
	public dynamic class CutScene1 extends Screen implements IKeyboard {
	    
	    private var my_counter:Number = 0;
		private var total_frames:Number = 500;
		private var childMovie;
		private var movieLoaded = false;
		private var killFlag = false;
		private var BUTTON_SHIFT = false;
	    
	    public function CutScene1() {
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
		    }
		}
	
		public function startLoad()
		{
			var mLoader:Loader = new Loader();
			var mRequest:URLRequest = new URLRequest("cut-scene-1.swf");
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
		}

		public function onCompleteHandler(loadEvent:Event)
		{
			childMovie = loadEvent.currentTarget.content;
			total_frames = childMovie.totalFrames;
	        this.addChild(childMovie);
	        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
	        stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
			movieLoaded = true;
			stage.frameRate = 30;
		}
		
		public function onProgressHandler(mProgress:ProgressEvent)
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
		}
	
	    
	    override public function update(evt = null):Boolean{
	        if(stage.frameRate == 30) {
	            my_counter++;
    			if(killFlag) {
    			    updateStatus(COMPLETE);
    			    stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
        	        stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
                    childMovie.stop();
    			    SoundMixer.stopAll();
    			    stage.frameRate = 60;
    			    return false;
    			} else if(childMovie.currentFrame >= total_frames && movieLoaded) {
    				updateStatus(COMPLETE);
    				stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
        	        stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
    				childMovie.stop();
    			    SoundMixer.stopAll();
    			    stage.frameRate = 60;
    				return false;
    			} else {
    				return true;				
                }
	        } else {
	            return true;
	        }
        }
        
    }
}