package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
	import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.actors.weapons.HatWeapon;
    import engine.actors.enemies.Enemy;
    import engine.IObserver;
    import engine.Scoreboard;
    import engine.actors.geoms.*;
    import engine.actors.specials.*;
    
	dynamic public class Map extends MovieClip implements IObserver, ISubject {
		
		public var observerArray:Array = new Array(); // this is the array of observers on the map
		public var subjectArray:Array = new Array(); // this is the array of subjects on the map
		
		private var observers:Array = new Array(); // this is the array of objects subscribed to this map
		
		private var screenPadding:Number = 90; // the number of pixels near the edge before the screen begins panning
		private var screenWidth:Number = 256; // how wide is our viewport
		private var screenHeight:Number = 208; // how high is our viewport
		
		private var myHero:Hero; // local variable for our player
		
		private var heroHP:Number = 3; // current HP of the hero, this is sorta convoluted
		
		private var status:String = 'ACTIVE'; // default status, i sort of forget what this is for
	    private var scoreboard:Scoreboard; // grab an instance of our scoreboard
		
		public function Map():void {
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
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
			for(var n=0; n<this.numChildren; n++){
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
    				    if(myChild is Cloud || myChild is Door || myChild is Block) {
    				        myChild.alpha = 0;
    				    }
    				}
    				if(myChild is Actor) {
    				    myChild.setMap(this);
    				}
    			}
    			
    			for(var s=0; s<subjectArray.length; s++) {
    		        for(var i=0; i<observerArray.length; i++) {
    		            subjectArray[s].addObserver(observerArray[i]); // subscribe all observers to our subject
    		        }
    		            subjectArray[s].addObserver(this); // and then subscribe the map itself
    		    }
    		    

			}
			//move to bottom screen of map
			//this.y = 0-(this.height - (game.screenHeight*2));
			trace("objects referenced.");
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		private function applySubscriptions(object) {
		    if(object is ISubject) {
			    subjectArray.push(object);
                for(var i=0; i<observerArray.length; i++) {
		            object.addObserver(observerArray[i]); // subscribe all observers to our subject
		        }
		        object.addObserver(this); // and then subscribe the map itself
			    if(object is Hero) {
			        myHero = object;
			        myHero.setMap(this);
			    }
			}
			if(object is IObserver) {
			    observerArray.push(object);
			    myHero.addObserver(object);
			    if(object is Cloud || object is Door || object is Block) {
			        object.alpha = 0;
			    }
			}
		}
		
		public function spawnActor(actor:Actor) {
		    this.addChild(actor);
		    applySubscriptions(actor);
		    actor.x = myHero.x;
		    actor.y = myHero.y + 5;
		}
		
		private function updateSubjects():void {
		    for(var i=0; i<subjectArray.length; i++) {
		        subjectArray[i].update();
		    }
		}
		
		private function removeSubject(subject):void {
		    for (var sb:int=0; sb<subjectArray.length; sb++) {
                if(subjectArray[sb] == subject) {
                    subjectArray.splice (sb,1); break;
                    break;
                }
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
		    this.x += 1; // bizarre framerate fix
		    this.x -= 1; // keeps things moving quickly on mac
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
		        }
		    } else if(subject is Door) {
		        status = 'COMPLETE';
		    }
		}
		
		public function removeFromMap(actor) {
            if(actor is IObserver) {
                removeObserver(actor);
            }
		    if(actor is ISubject) {
		        removeSubject(actor);
		    }
    	    this.removeChild(actor);
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
		
		private function customUpdate():void {
		    // this will be replaced later
            // by children of this class, should they
            // require it
		}
		
		public function update():Boolean {
		    customUpdate();
		    updateSubjects();
		    
		    if(status == 'COMPLETE') {
		        return false;
		    } else {
		        if(myHero.myStatus == 'DEAD') {
		            status = 'HERO DEAD';
		            return false;
		        } else {
		            return true;
		        }
		    }
		}
	}
}