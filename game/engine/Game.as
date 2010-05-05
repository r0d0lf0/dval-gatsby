package engine{
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import controls.KeyMap;
	import engine.Map;
	import engine.actors.Hero;
	
	public class Game extends MovieClip {

		private const MOVE_BUFFER:int = 60;
		private var screenWidth:Number;
		private var screenHeight:Number;
		public var keys:KeyMap;
		public var map:Map;
		public var hero:Hero = new Hero();
		
		public function Game() {
			//find where in flash spacetime are we
			if (stage != null) {
				buildEnviron();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			buildEnviron();
		}
		//once onStage, set basic globals
		private function buildEnviron() {
			//controls
			keys = new KeyMap();
			stage.addChild(keys);
			//used in calculating movement buffer
			screenWidth = (stage.stageWidth/2);
			screenHeight = (stage.stageHeight/2);
		}
		//clears old and set new
		public function loadLevel(lmap:Map,spawnPoint:Point = null):void{
			if(stage.getChildByName('map')){
				stage.removeChild(map);
				stage.removeChild(hero);
				stage.removeEventListener(Event.ENTER_FRAME, runEngine);
			}
			//trace(lmap.toString().substring(7,10));
			map = lmap
			map.name = 'map';
			hero.name = 'hero'; 
			if(lmap.toString().substring(8,11) == 'lvl'){
				if(spawnPoint != null){
					hero.x = spawnPoint.x; 
					hero.y = spawnPoint.y; 
				}else{
					hero.x = 16; 
					hero.y = 200; 
				}
				hero.ldir = true;
				hero.imon = false;
				hero.vely = 0;
				stage.addChild(map);
				stage.addChild(hero);
				stage.addEventListener(Event.ENTER_FRAME, runEngine);
			}else{
				stage.addChild(map);
			}
		}
		//update positions on every frame. 
		//Checks if hero is in the MOVE_BUFFER, and move Hero.
		//else hero is at MOVE_BUFFER limit and map scrolls instead.
		private function runEngine(evt) {
			//invoke emotion in hero
			hero.moveMe();
			// up|down
			if ((hero.y < screenHeight-MOVE_BUFFER && hero.vely<0) || (hero.y > screenHeight+MOVE_BUFFER && hero.vely>0)) {
				map.y -= hero.vely;
			} else {
				hero.y += hero.vely;
			}
			// left|right
			if (hero.velx < 0) {
				if (map.x < 0) {
					if (hero.x > (screenWidth-MOVE_BUFFER)) {
						hero.x += hero.velx;
					} else {
						map.x -= hero.velx;
					}
				} else {
					map.x = 0;
					hero.x += hero.velx;
					if (hero.x<0) {
						hero.x = 0;
					}
				}
			} else if (hero.velx > 0){
				if (map.x > (screenWidth*2)-map.width) {
					if (hero.x < (screenWidth+MOVE_BUFFER)) {
						hero.x += hero.velx;
					} else {
						map.x -= hero.velx;
					}
				} else {
					map.x = (screenWidth*2)-map.width;
					hero.x += hero.velx;
					if (hero.x > (screenWidth*2)-hero.width) {
						hero.x = (screenWidth*2)-hero.width;
					}
				}
			}
		}
	}
}