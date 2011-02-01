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
	
	public dynamic class TrainEnding extends Screen {
	    
	    private var my_counter:Number = 0;
		private var total_frames:Number = 500;
		private var childMovie;
		private var movieLoaded = false;
	    private var killFlag = false;
	    private var BUTTON_SHIFT = false;
	    private var mLoader;
	    private var soundChannel;
	    private var musicChannel;
	    
	    private var velx = 3;
	    private var train_background; 
	    private var nick_train; 
	    private var the_end;
	    private var movieOver = false;
	    
	    public function TrainEnding() {
			startLoad();	
	    }
	
		public function startLoad()
		{
            
            train_background = getMovieFromLibrary("TrainEndingBackground");
            train_background.y = 240;
            addChild(train_background);
            
            nick_train = getMovieFromLibrary("NickTrain");
            nick_train.y = 136;
            nick_train.x = 48;
            addChild(nick_train);
            
            the_end = getMovieFromLibrary("TheEnd");
            the_end.x = 160;
            the_end.y = 48;
            addChild(the_end);
            
            
            
            //frame = new Bitmap(new cutscene_frame(0, 0));
            //addChild(frame);
            movieLoaded = true;
		}
		
		private function getMovieFromLibrary(mcIName:String){
			var tMC:Class = getDefinitionByName(mcIName) as Class;
			var newMc:MovieClip = new tMC() as MovieClip;
			return newMc;
		}
		
		public function cutsceneOver() {
		    movieOver = true;
		}
	
	    override public function update(evt = null):Boolean{
	        my_counter++;
	        if(movieLoaded) {
	            train_background.update();
	            nick_train.update();
	        }
	        if(nick_train.x >= 256) {
	            the_end.drawing = true;
	            the_end.update();
	        }
//	        nick_train.update();
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