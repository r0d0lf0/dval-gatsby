package engine.actors{

    import engine.IObserver;
    import engine.ISubject;
    import engine.Map;
    import engine.actors.player.Hero;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import engine.ISubject;
	
	import engine.actors.ActorScore;
	

	dynamic public class Actor extends MovieClip implements IObserver, ISubject {
	    
	    public static const DEFAULT = 1;
        public static const ACTIVE = 2;
        public static const PAUSING = 30;
        public static const PAUSED = 31;
        public static const COMPLETE = 4;
        public static const HERO_DEAD = 5;
        public static const GAME_OVER = 6

        public var points = 50;

		public var isRemoved = false;
        protected var observers:Array = new Array();
		protected var me:Point = localToGlobal(new Point(0,0));
		protected var onStage:Boolean = false;
		protected var myMap:Map;
		public var myStatus = 'INACTIVE';
		public var alwaysOn = false;
		private var actor:*;
		private var ldr;
		
		protected var myScore;
		
		protected var HP:Number = 1;
		
		public var collide_left:int = 8; // what pixel do we collide on on the left
		public var collide_right:int = 20; // what pixel do we collide on on the right
		
		public var collide_left_ground:int = 12;
		public var collide_right_ground:int = 16;
		
		public var goingLeft = 0;
		
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
			myScore = new ActorScore(points, this.x, this.y); 
		    setup();
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function getStatus() {
			return myStatus;
		}
		
		public function setup() {
		    // this will get overwritten later
		}
		
		//clean up and free resources
		public function onRemove(evt:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function getHP() {
			return HP;
		}
		
		//handles loading textures in the library
		public function skin(tex):Bitmap {
			var ClassReference:Class = getDefinitionByName(tex) as Class;
			var newScreen = new ClassReference();
			return newScreen;
		}
		
		public function checkCollision(subject) {
		    
		    var myRight, myLeft, subRight, subLeft;
		    
		    if(goingLeft) {
		        myLeft = this.width - collide_right;
		        myRight = this.width - collide_left;
		    } else {
		        myLeft = collide_left;
		        myRight = collide_right;
		    }
		    
		    if(subject.goingLeft) {
		        subLeft = subject.width - subject.collide_right;
		        subRight = subject.width - subject.collide_left;
		    } else {
		        subRight = subject.collide_right;
		        subLeft = subject.collide_left;
		    }
		    
		    if((subject.x + subRight) >= this.x + myLeft && (subject.x + subLeft) <= this.x + myRight) {
		        if((this.y + this.height) >= subject.y && this.y <= (subject.y + subject.height)) {
		            return true;
		        }
		    }
		    return false;
		}
	    
		
		public function checkGroundCollision(subject) {
		    if((subject.x + subject.collide_right_ground) >= this.x && (subject.x + subject.collide_left_ground) <= this.x + this.width) {
		        if((this.y + this.height) >= subject.y && this.y <= (subject.y + subject.height)) {
		            return true;
		        }
		    }
		    return false;
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
		    if(checkCollision(subject)) { // if we're colliding with the subject
		        subject.collide(this); // then collide with them
		    }
		}
		
		public function collide(observer, ...args) {
		    // this will get overwritten later, for use by observers when they collide with us
		}
		
		public function setMap(map:Map):void {
		    myMap = map;
		}
		
		public function getMap() {
			return myMap;
		}
		
		// the hero will use this to deal damage
        public function receiveDamage(attacker):void {
            HP -= attacker.damage;
            if(HP <= 0) {
                HP = 0;
                if(attacker.velX > 0) {
                    this.velx = 1;
                } else {
                    this.velx = -1;
                }
            }
        }
		
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		public function isObserver(observer):Boolean {
		    for(var ob:int=0; ob<observers.length; ob++) {
		        if(observers[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
		}
		
		public function removeObserver(observer):void {
		    for (var ro:int=0; ro<observers.length; ro++) {
                if(observers[ro] == observer) {
                    observers.splice(ro,1);
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
