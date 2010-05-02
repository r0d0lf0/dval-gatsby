﻿package engine.actors{
	
	import flash.geom.Point;
	import engine.actors.MapObject;
	import engine.maps.lvl1_2;
	import controls.KeyMap;
	//import flash.events.Event;

	dynamic public class Door1_2 extends MapObject{
		
		//public static const OPEN_DOOR:String = 'doorOpen';
		
		public function Door1_2(w=1,h=1,tex = null):void{
			super(w,h,tex);
		}
		public override function behave(smackData:Object,characterObject:*):void{
			
			var dx = smackData.dx;
			var ox = smackData.ox;
			//var dy = smackData.dy;
			//var oy = smackData.oy;
			
			if(ox > dx){
				if(KeyMap.keyMap[32] || KeyMap.keyMap[38]){
					trace('working');
					//dispatchEvent(new Event(OPEN_DOOR));
					parent['lvlLoader'].loadLevel(new lvl1_2(parent['lvlLoader']),new Point(16,480));
				}
			}
		}
	}
}