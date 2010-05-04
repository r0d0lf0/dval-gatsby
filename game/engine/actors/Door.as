package engine.actors{
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import engine.actors.MapObject;
	import engine.maps.*;
	import controls.KeyMap;
	//import flash.events.Event;

	dynamic public class Door extends MapObject{
		
		//public static const OPEN_DOOR:String = 'doorOpen';
		
		public function Door(w=1,h=1,tex = null):void{
			super(w,h,tex);
		}
		public override function behave(smackData:Object,characterObject:*):void{
			
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
					var levelToLoad:Object = new classRef(parent['lvlLoader']); 
					//call loadLevel() from reference
					parent['lvlLoader'].loadLevel(DisplayObject(levelToLoad),new Point(16,480));
				}
			}
		}
	}
}