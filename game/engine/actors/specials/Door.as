package engine.actors.specials {
	
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName; //sometime, the things we learn...
	import controls.KeyMap;
	import engine.IObserver;
	import engine.ISubject;
	import engine.actors.Actor;
	import engine.actors.player.Hero;

	dynamic public class Door extends Actor implements IObserver, ISubject {
		
		private var observers:Array = new Array();
		
		public function Door():void{
			super();
		}
		
		public function behave(smackData:Object,characterObject:*):void{
			
			var dx = smackData.dx;
			var ox = smackData.ox;
			
			// if touch center of door
			if(ox > dx){
				//if we press up
				if(KeyMap.keyMap[32] || KeyMap.keyMap[38]){
					//create Class refference from the name of the door
					//this is both awesome and important
					//as name of the door determines which level to load
					var classRef:Class = getDefinitionByName(String('engine.maps.'+this.name)) as Class;
					var levelToLoad:Object = new classRef(parent['game']); 
					//call loadLevel() from parent reference to global namespace
					parent['game'].newLevel(DisplayObject(levelToLoad),new Point(16,100),new Point(0,0));
				}
			}
		}
		
		public function notify(subject:*):void {
		    if(subject is Hero) {
		        if(subject.y >= this.y && subject.y <= (this.y+this.height)) {
    		        if(subject.x >= this.x && subject.x <= (this.x+this.width)) {
    		            notifyObservers();
    		        }
    		    }
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
	}
}