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
	
	public dynamic class GraveyardEnding extends Screen {
	    
	    private var my_counter:Number = 0;
		private var total_frames:Number = 500;
		private var childMovie;
		private var movieLoaded = false;
	    private var killFlag = false;
	    private var BUTTON_SHIFT = false;
	    private var mLoader;
	    private var soundChannel;
	    private var musicChannel;
	    
	    private var music = new graveyard_music();
	    private var velx = 3;
	    private var screen_background; 
	    private var coffin; 
	    private var the_end;
	    private var movieOver = false;
	    
	    public function GraveyardEnding() {
			startLoad();	
	    }
	
		public function startLoad()
		{
            
            screen_background = new Bitmap(new graveyard_background(0, 0));
            addChild(screen_background);
            
            coffin = getMovieFromLibrary("Coffin");
            coffin.y = 360;
            coffin.x = 88;
            addChild(coffin);

            musicChannel = music.play(0);
            
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
                coffin.update();
	        }
            if(my_counter > 120 && screen_background.y > -208) {
                screen_background.y--;
                coffin.y--;
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