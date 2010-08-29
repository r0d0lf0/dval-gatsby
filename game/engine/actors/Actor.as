package engine.actors{

    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.player.Hero;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import engine.ISubject;
	

	dynamic public class Actor extends MovieClip implements ISubject, IObserver {

        protected var observers:Array = new Array();
		protected var me:Point = localToGlobal(new Point(0,0));
		protected var onStage:Boolean = false;
		private var actor:*;
		private var ldr;
		
		public var collide_left:int = 10; // what pixel do we collide on on the left
		public var collide_right:int = 22; // what pixel do we collide on on the right
		
		//so nice
		//public var imgLdr = new ImageLoader(textureLoadSuccess,textureLoadFail);
		//The constructor 
		// initialize instance variables and see 
		// if its 'safe' to add listeners.
		//public function Actor(w,h,tex = null):void {
		public function Actor():void {
			//Check we exist in Flash spacetime
			if (stage != null) {
				buildObject();
			} else {  
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildObject();
		}
		
		//initialize object after it's on stage
		public function buildObject():void {
		    onStage = true;
		    setup();
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			//this.addEventListener(Event.ENTER_FRAME, onFrame);
			//doTexture(this.tex);
		}
		
		public function setup() {
		    // this will get overwritten later
		}
		
		//clean up and free resources
		public function onRemove(evt:Event):void{
			//this.removeEventListener(Event.ENTER_FRAME, onFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		//handles loading textures in the library
		public function skin(tex):Bitmap {
			var ClassReference:Class = getDefinitionByName(tex) as Class;
			var newScreen = new ClassReference();
			return newScreen;
		
			//written this way for levelEDitor compatibility
			//if tex is null, load a Charlie (It's white square! hahahaha)
			/*if (tex != null && tex != undefined && tex!= '') {
				imgLdr.load(tex);
			} else {
				textureLoadFail();
			}*/
		}/*
		//check if the thing hit the Hero
		//look up "Axis based collisions"
		private function onFrame(evt:Event):void{
			
		}*/
		
		public function checkCollision(subject) {
		    if((subject.x + subject.collide_right) >= this.x && (subject.x + subject.collide_left) <= this.x + this.width) {
		        if((this.y + this.height) >= subject.y && this.y <= (subject.y + subject.height)) {
		            return true;
		        }
		    }
		}
		
		//show the background image
		public function textureLoadSuccess(evt:*):void {
			var tmpData:BitmapData = evt.target.content.bitmapData;
			var tmp:Bitmap = new Bitmap(tmpData);
			//tmp.scaleX = 2;
			//tmp.scaleY = 2;
			this.addChild(tmp);
		}
		//show blank
		public function textureLoadFail(evt:*=null):void {
			var tmpData:BitmapData = new BitmapData((this.w*this.unit),(this.h*this.unit),true,0x00FFFFFF);
			var tmp:Bitmap = new Bitmap(tmpData);
			this.addChild(tmp);
		}
		
		public function update():void {
			//this is overwritten by each unique subclass
		}
		
		public function notify(subject:*):void {
		    // this will be overwritten
		}
		
		public function addObserver(observer):void {
		    observers.push(observer);
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice(ob,1);
                    break;
                }
            }
		}
		
	    public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
	}
}
