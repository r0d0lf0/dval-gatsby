package engine{

	import flash.events.Event;
	import flash.display.MovieClip;
	import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.actors.weapons.Weapon;
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
		
		private var status:String = 'DEFAULT'; // default status, i sort of forget what this is for
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
		
		private function updateSubscriptions():void {
		    for(var p=0; p<this.numChildren; p++) { // for all the map's children
		        var myChild = this.getChildAt(p);   // get them into a variable
		        if(myHero is Hero) { // if we've already got our hero defined
		            if(Math.abs(myHero.x - myChild.x) < screenWidth || myChild is Geom) { // if they're within a certain range of the hero, or a geom
    	                registerActor(myChild); // register them
    		        } else { // or if they aren't in a certain range or a geom
    		            deregisterActor(myChild); // deregister them
    		        }
		        } else if(myChild is Hero) { // otherwise, if we don't have a hero, and this is a hero
		            registerActor(myChild); // register our hero
		            myHero = myChild; // and set him officially as our hero
		        }
		    }
		}
		
		private function buildMap():void {
		    // loop through all the child objects attached to this library item, and put
		    // references to them into appropriate local arrays.  Afterwards, we'll subscribe
		    // them to each other, and to the map itself
    		status = 'ACTIVE';
    		updateSubscriptions();
			notifyObservers(); // tell our observers that we've completed our load out
		}
		
		public function spawnActor(actor:Actor, x = 0, y = 0) {
		    this.addChild(actor); // add our actor to the stage
		    registerActor(actor); // and register it with our map
		    actor.x = x; // set its x coord
		    actor.y = y; // and its y coord
		}
		
		private function registerActor(actor) {
		    if(actor is ISubject) { // if the actor is a subject
		        if(!subjectExists(actor)) { // and they haven't been registered yet
    		        subjectArray.push(actor); // add them to our subjects array
    		        actor.addObserver(this); // and subscribe the map to them
    		        subscribeAllTo(actor); // and subscribe all our observers to it
    		    }
		    }
		    if(actor is IObserver) { // if they're an observer
		        if(!observerExists(actor)) { // and they're not in our observers list
    		        observerArray.push(actor); // add them to it
    		        for(var s=0; s<subjectArray.length; s++) { // and go through every subject on our map
                        subjectArray[s].addObserver(actor);  // and subscribe our observer to them
                    }
    		    }
		    }
		    if(actor is Actor) { // if our actor is an actor
		        actor.setMap(this); // set ourselves as the actor's map
		    }
		    if(actor is Block || actor is Cloud || actor is Door) { // if they're a virtual geom
		        actor.alpha = 0; // make them invisible
		    }
		}
		
		private function unsubscribeAllFrom(actor) {
		    for(var q:int=0; q<observerArray.length; q++) { // and then loop through all our observers
                actor.removeObserver(observerArray[q]); // and unsubscribe them from our actor  
            }
		}
		
		private function subscribeAllTo(actor) {
		    for(var q:int=0; q<observerArray.length; q++) {
		        actor.addObserver(observerArray[q]);
		    }
		}
		
		private function deregisterActor(actor) {
		   if(actor is ISubject) { // if he's a subject
		       for (var sb:int=0; sb<subjectArray.length; sb++) { // go through all of our subjects
                   if(subjectArray[sb] == actor) { // and when you find the subject that's our subject
                       unsubscribeAllFrom(actor); // get this off everythang
                       subjectArray.splice(sb,1); // remove it from the array
                   }
               }
		   }
		   if(actor is IObserver) { // if he's an observer
		       for (var ob:int=0; ob<observerArray.length; ob++) { // loop through all our observers
                   if(observerArray[ob] == actor) { // and when you find the one that's him
                       observerArray.splice (ob,1); // remove him from the array
                       for(var k:int=0; k<subjectArray.length; k++) { // and loop through all our subjects
                           subjectArray[k].removeObserver(actor); // and unsubscribe our observer from them
                       }
                   }
               }
		   }
		}
		
		private function updateSubjects():void {
		    for(var k:int=0; k<subjectArray.length; k++) {
		        subjectArray[k].update();
		    }
		}
		
		private function subjectExists(subject):Boolean {
		    for(var i = 0; i < subjectArray.length; i++) {
		        if(subject == subjectArray[i]) {
		            return true;
		            trace("subject exists!");
		        }
		    }
		    return false;
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
            deregisterActor(actor);
    	    this.removeChild(actor);
    	}
		
		public function addObserver(observer):void {
		    if(!isObserver(observer)) {
		        observers.push(observer);
		    }
		}
		
		private function observerExists(observer):Boolean {
		    for(var ob:int=0; ob<observerArray.length; ob++) {
		        if(observerArray[ob] == observer) {
		            return true;
		        }
		    }
		    return false;
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
		    for (var ob:int=0; ob<observers.length; ob++) {
                if(observers[ob] == observer) {
                    observers.splice (ob,1);
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
		    if(status != 'DEFAULT') {
    		    customUpdate();
    		    updateSubjects();
    		    updateSubscriptions();
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
		    } else {
		        return true;
		    }
		}
	}
}