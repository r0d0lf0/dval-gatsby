package engine.actors{

	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import engine.ISubscriber;
	import engine.ISubject;
	

	dynamic public class Actor extends MovieClip {

		protected var me:Point = localToGlobal(new Point(0,0));
		private var actor:*;
		private var ldr;
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
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			//this.addEventListener(Event.ENTER_FRAME, onFrame);
			//doTexture(this.tex);
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
		
		public function checkCollision(actor) {
		    
		    //actor x axis
			var hhw = actor.width/4; // Hero Half-Width
			
			//mapObject x axis
			this.me = localToGlobal(new Point(0,0));
			var mhw = this.width/2; // MapObject Half-Width
			
			//distance and overlap between them
			var dx = (me.x+mhw) - (actor.x+hhw+actor.velx+actor.Xspeed);  //distance x
			var ox = (hhw+mhw) - Math.abs(dx);  //overlap x
			
			/*************** Check for collision ********************/
			//if there is a collision on the X axis:
			if(ox > 0){
				//then spend resources checking for Y axis collision
				//actor Y axis
				var hhh = actor.height/2;
				//mapObject Y axis
				var mhh = this.height/2;
				//distance and overlap between them
				var dy = (me.y+mhh) - (actor.y-hhh+actor.vely+actor.Yspeed);
				var oy = (hhh+mhh) - Math.abs(dy);
				//if there is collision on Y:
				if(oy > 0){
					//we have a hit! mapObject should 'behave' accordingly
					//onHit({dx:dx,ox:ox,dy:dy,oy:oy},actor);
					//tell the actor he hit something (this effects animation)
					//actor.ihit = true;
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
		
		
		public function addSubscription(target:MovieClip):void{
			//
		}
		public function cancelSubscription(target:MovieClip):void{
			//
		}
	}
}
