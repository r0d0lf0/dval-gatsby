package engine.actors{
	
	import engine.actors.MapObject;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName; //sometime, the things we learn...
	import controls.KeyMap;

	dynamic public class Door extends MapObject{
		
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
					var levelToLoad:Object = new classRef(parent['game']); 
					//call loadLevel() from parent reference to global namespace
					parent['game'].newLevel(DisplayObject(levelToLoad),new Point(16,480));
				}
			}
		}
	}
}