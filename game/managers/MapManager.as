package managers{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import engine.Level;
	import engine.Engine
	import controls.KeyMap;

	dynamic public class MapManager {
		
		static private var mapList:Array;
		static public var currentMap:String;
		static public var level:Level;
		
        public function LevelManager(mapList:Array) {
            this.mapList = mapList;
        }
		
		public function getMap(map:String) {
		    trace('mapsearch: '+map.toString().search('Level'));
			//if(map.toString().search('Level')>-1){
				//load level
				//trace(String('engine.levels.'+map));
				//var ClassReference:Class = getDefinitionByName(String('engine.levels.'+map)) as Class;
				//var peep = new ClassReference();
				//currentMap = map;
				//level.addChild(peep);
				//trace('leveled');
			//}else{
				var ClassReference:Class = getDefinitionByName(map) as Class;
				var peep = new ClassReference();
				currentMap = map;
				level.addChild(peep);
		}
		
		// simple combo
		public function setMap(map:String):void{
			clearMap();
			for(var i in mapList){
				if(mapList[i] == map){
					loadMap(map);
				}
			}
		}
		// allows itteration
		public function nextMap():void{
			clearMap();
			var place:int = 0;
			for(var i in mapList){
				if(mapList[i] == currentMap){
					place = i;
				}
			}
			MapManager.loadMap(mapList[place+1]);
		}
		//load a new map or level
		public function loadMap(map:String):void{
			
			trace('mapsearch: '+map.toString().search('Level'));
			//if(map.toString().search('Level')>-1){
				//load level
				//trace(String('engine.levels.'+map));
				//var ClassReference:Class = getDefinitionByName(String('engine.levels.'+map)) as Class;
				//var peep = new ClassReference();
				//currentMap = map;
				//level.addChild(peep);
				//trace('leveled');
			//}else{
				var ClassReference:Class = getDefinitionByName(map) as Class;
				var peep = new ClassReference();
				currentMap = map;
				level.addChild(peep);
			//}

		}
		
		//removes everything but the LevelManager
		public function clearMap():void{
			for(var i:int=0;i<level.numChildren; i++){
				var gc:* = level.getChildAt(i);
				if(!(gc is Engine) && !(gc is KeyMap)){
					level.removeChild(level.getChildAt(i));
					trace('cleared');
				}
			}
		}
		// returns a list of maps,
		//a specific map, or an empty array
		public function getMaps(map:int = -1):Array {
			var tempArr:Array = new Array();
			if (map < 0){
				tempArr = mapList;
			}else if (int(map)){
				tempArr = new Array(mapList[map]);
			}
			return tempArr;
		}
		
		public function setLevel(l:Level):void{
			level = l;
		}
		
	}//end class
}//end package