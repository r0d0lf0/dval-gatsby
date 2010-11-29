package engine.actors.specials {
		
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName; //sometime, the things we learn...
	import controls.KeyMap;
	import engine.IObserver;
	import engine.ISubject;
	import engine.actors.Actor;
	import engine.actors.player.Hero;

	dynamic public class Door extends Actor {
				
		public function Door():void{
			super();
		}
		
		override public function notify(subject:*):void {
		    if(subject is Hero) {
		        if(subject.y >= this.y && subject.y <= (this.y+this.height)) {
    		        if(subject.x >= this.x && subject.x <= (this.x+this.width)) {
    		            notifyObservers();
    		        }
    		    }
		    }
		}
		
	}
}