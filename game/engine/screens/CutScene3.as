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
    import engine.IKeyboard;
    import flash.ui.Keyboard;
    import controls.KeyMap;	
    import flash.media.SoundMixer;
    
    public dynamic class CutScene3 extends Screen {
	
	private var my_counter:Number = 0;
	private var total_frames:Number = 500;
	private var childMovie;
	private var movieLoaded = false;
	private var killFlag = false;
	private var BUTTON_SHIFT = false;
	private var mLoader;
	
	public function CutScene3() {
	    startLoad();	
	}
	
	public function keyUpHandler(evt):void {
	    if(evt.keyCode == Keyboard.SPACE) {
		BUTTON_SHIFT = false;
	    }
	}
	
	public function keyDownHandler(evt):void {
	    if(evt.keyCode == Keyboard.SPACE && BUTTON_SHIFT == false) { // if someone's hitting enter anew
                killFlag = true;
                BUTTON_SHIFT = true;
	    }
	}
	
	public function startLoad()
	{
	    mLoader = new Loader();
	    var mRequest:URLRequest = new URLRequest(SWF_DIR + "cut-scene-3.swf");
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
	}
	
	public function onProgressHandler(mProgress:ProgressEvent)
	{
	    var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
	}
	
	override public function update(evt = null):Boolean{
	    if(movieLoaded) {
		my_counter++;
		if(killFlag) {
		    updateStatus(COMPLETE);
		    stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
    	            stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
                    childMovie.stop();
                    mLoader.unload();
		    SoundMixer.stopAll();
		    stage.frameRate = 60;
		    childMovie = null;
		    return false;
		} else if(childMovie.currentFrame >= total_frames && movieLoaded) {
		    updateStatus(COMPLETE);
		    stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler); // and subscribe him to the keyboard
    	            stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler); // in both its forms
		    childMovie.stop();
		    SoundMixer.stopAll();
		    childMovie = null;
		    stage.frameRate = 60;
		    return false;
		}
	    }
	    return true;
	}
    }
}