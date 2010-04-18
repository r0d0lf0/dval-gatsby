package engine{
	
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import controls.KeyMap;
	import engine.Map;
	import engine.actors.Hero;
	import engine.actors.Block;
	
	public class Game extends MovieClip {

		private const MOVE_BUFFER:int = 100;
		private var screenWidth:Number;
		private var screenHeight:Number;

		public var map:Map = new Map();
		public var hero:Hero = new Hero();
		public var block:Block = new Block();
		public var block2:Block = new Block();
		
		public function Game() {
			//trace("game loaded");
			if (stage != null) {
				buildDisplay();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			buildDisplay();
		}
		private function buildDisplay() {
			//tempmap
			stage.addChild(block);
			block.x = -20;
			block.y = 378;
			stage.addChild(block2);
			block2.x = 320;
			block2.y = 300;
			//continuing...
			stage.addChild(map);
			stage.addChild(hero);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME, runEngine);
			
			screenWidth = (stage.stageWidth/2);
			screenHeight = (stage.stageHeight/2);
			
			//map.getMap('maps/lvl_01_01.txt');
		}
		private function runEngine(evt) {
			//invoke emotion in hero
			hero.moveMe();
			map.objectCheckHit(hero);
			// moves the hero or map, pending hero position
			// up|down
			//if ((hero.y < screenHeight-MOVE_BUFFER && hero.vely<0) || (hero.y > screenHeight+MOVE_BUFFER && hero.vely>0)) {
				//map.y -= hero.vely;
			//} else {
				hero.y += hero.vely;
			//}
			// left|right
			if (hero.velx < 0) {
				//if (map.x < 0) {
					if (hero.x > screenWidth-MOVE_BUFFER) {
						hero.x += hero.velx;
					//} else {
						//map.x -= hero.velx;
					}
				//} else {
					//map.x = 0;
					//hero.x += hero.velx;
					//if (hero.x<0) {
						//hero.x = 0;
					//}
				//}
			} else if (hero.velx > 0){
				//if (map.x > ((map.bounds*-1)+(screenWidth*2)-20)) {
					if (hero.x < screenWidth+MOVE_BUFFER) {
						hero.x += hero.velx;
					//} else {
						//map.x -= hero.velx;
					}
				//} else {
					//map.x = (map.bounds*-1)+(screenWidth*2)-20;
					//hero.x += hero.velx;
					//if (hero.x > (screenWidth*2)-hero.width) {
						//hero.x = (screenWidth*2)-hero.width;
					//}
				//}
			}
		}
		//update keyMappin class
		public function keyDownHandler(evt:KeyboardEvent):void {
			KeyMap.keyMap[evt.keyCode] = true;
		}
		public function keyUpHandler(evt:KeyboardEvent):void {
			KeyMap.keyMap[evt.keyCode] = false;
		}
	}
}