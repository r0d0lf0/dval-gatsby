package engine.screens{

    import flash.display.MovieClip;
	import engine.Map;
	import flash.events.MouseEvent;
	import engine.Screen;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	
	public dynamic class CutScene1 extends Screen {
	    
	    private var my_counter:Number = 0;
		private var total_frames:Number = 500;
		private var childMovie;
		private var movieLoaded = false;
	    
	    public function CutScene1() {
			startLoad();	
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
			movieLoaded = true;
		}
		
		public function onProgressHandler(mProgress:ProgressEvent)
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
		}
	
	    
	    override public function update(evt = null):Boolean{
			my_counter++;
			if(childMovie.currentFrame >= total_frames && movieLoaded) {
				updateStatus(COMPLETE);
				return false;
			} else {
				return true;				
			}
		}
	    
	}
}