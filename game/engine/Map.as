package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
    import engine.actors.player.Hero;
    import engine.actors.enemies.Enemy;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.geoms.*;
    import engine.actors.specials.*;
    
	dynamic public class Map extends MovieClip implements IObserver, ISubject {
		
		public var observerArray:Array = new Array(); // this is the array of observers on the map
		public var subjectArray:Array = new Array();
		public var objectArray:Array = new Array();
		
		private var observers:Array = new Array(); // this is the array of objects subscribed to this
		
		private var screenPadding:Number = 90;
		private var screenWidth:Number = 256;
		private var screenHeight:Number = 208;
		
		private var myHero:Hero;
		
		private var heroHP:Number = 3; // current HP of the hero
		
		private var status:String = 'ACTIVE';
	    private var scoreboard:Scoreboard;

		//public var game:MovieClip;
		//private var hero:Hero;
		
		public function Map():void {
			//trace("game loaded");
			if (stage != null) {
				buildMap();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage(evt):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			scoreboard = Scoreboard.getInstance();
			buildMap();
		}
		
		private function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into a local array
			for(var n=0; n<this.numChildren; n++){
				//trace(this.getChildAt(n));
				var myChild = this.getChildAt(n);
				if(myChild is ISubject) {
				    subjectArray.push(myChild);
				    if(myChild is Hero) {
				        myHero = myChild;
				    }
				}
				if(myChild is IObserver) {
				    observerArray.push(myChild);
				    if(myChild is Cloud) {
				        myChild.alpha = 0;
				    } if(myChild is Door) {
				        myChild.alpha = 0;
				    }
				}
				objectArray.push(this.getChildAt(n));
			}
			
			
			    for(var s=0; s<subjectArray.length; s++) {
			        for(var i=0; i<observerArray.length; i++) {
			            subjectArray[s].addObserver(observerArray[i]);
			        }
			            subjectArray[s].addObserver(this);
			    }
			
			
			//move to bottom screen of map
			//this.y = 0-(this.height - (game.screenHeight*2));
			trace("objects referenced.");
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		private function updateSubjects():void {
		    for(var i=0; i<subjectArray.length; i++) {
		        subjectArray[i].update();
		    }
		}
		
		private function moveMap(subject):void {
		    var stageLeft = -this.x + screenPadding;
		    var stageRight = -this.x + (screenWidth - screenPadding);
		    if(subject.x < stageLeft) {
		       this.x = -subject.x + screenPadding;
		    } else if(subject.x > stageRight) {
		        this.x = -subject.x + (screenWidth - screenPadding);
		    }
		    
		    if(this.x < -this.width + screenWidth) {
		        this.x = -this.width + screenWidth;
		    } else if(this.x > 0) {
		        this.x = 0;
		    }
		    this.x += 1;
		    this.x -= 1;
		}
		
		public function getHeroHP():Number {
		    return heroHP;
		}
		
		public function notify(subject:*):void {
		    if(subject is Hero) {
		        moveMap(subject);
		        if(heroHP != subject.getHP()) { // if our hero's HP has changed
		            heroHP = subject.getHP(); // reset our holder for HP
		            notifyObservers(); // and tell the level about it
		            trace("LIFE LOST");
		        }
		    } else if(subject is Door) {
		        status = 'COMPLETE';
		    }
		}
		
		public function addObserver(observer):void {
		    observers.push(observer);
		}
		
		public function removeObserver(observer):void {
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1); break;
                    break;
                }
            }
		}
		
		public function notifyObservers():void {
		    for(var ob=0; ob<observers.length; ob++) {
		        observers[ob].notify(this);
		    }
		}
		
		public function getStatus():String {
		    return status;
		}
		
		public function update():Boolean {
		    updateSubjects();
		    if(heroHP) {
		        if(status == 'COMPLETE') {
		            return false;
		        } else {
		            return true;
		        }
		    } else {
		        status = 'HERO DEAD';
		        return false;
		    }
		    
		}
	}
}