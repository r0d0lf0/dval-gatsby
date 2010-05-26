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
		public var screenWidth:Number;
		public var screenHeight:Number;
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
		public function newLevel(lmap:Map,pSpawn:Point = null,pMapOffset:Point = null):void{
			//if we already have map, remove it (we wouldn't call this unless we're done a level anyway)
			if(stage.getChildByName('map')){
				destroyLevel();
			}
			//set up map and hero environmental vars
			map = lmap
			map.name = 'map';
			hero.name = 'hero';
			//if we're loading a level (prefixed by 'lvl'):
			if(lmap.toString().substring(8,11) == 'lvl'){
				//load and populate level
				createLevel(pSpawn,pMapOffset);
			}
			else{// we're probably loading a splashScreen (prefixed by 'scrn')
				// so just add the splash screen.
				createSplash(pSpawn,pMapOffset);
			}
			/**************************************************************/
			//TODO: other 'level' types. possibly such as: 
			//scrnEnd, scrnSequence, lvlSequence, lvlboss, lvlBonus_1, etc. 
			/**************************************************************/
			
		}
		//load new splash
		public function createSplash(pSpawn:Point = null,pMapOffset:Point = null):void{
				stage.addChild(map);
		}
		//load new stuff, start engine
		public function createLevel(pSpawn:Point = null,pMapOffset:Point = null):void{
			
			/*************** Hero display set up ************************/
			if(pSpawn == null){
				hero.x = 0; 
				hero.y = 0; 
			}else{
				hero.x = pSpawn.x; 
				hero.y = pSpawn.y; 
			}
			//assume we want to start the level 'looking right'
			hero.ldir = true;
			//try and prevent jump....(or find different command for entering the door)
			hero.imon = false;
			hero.vely = 0;
			
			/**************** Map display set up***********************/
			if(pMapOffset == null){
				map.x = 0; 
				map.y = 0; 
			}else{//
				map.x = pMapOffset.x; 
				map.y = pMapOffset.y; 
			}
			/**************** Level ***********************/
			//add all the pieces to the stage
			stage.addChild(map);
			stage.addChild(hero);
			startEngine();
		}
		//remove anything that would interfere with a clean  load
		public function destroyLevel():void{
			stage.removeChild(map);
			if(stage.getChildByName('hero')){
				stage.removeChild(hero);
				stopEngine();
			}
		}
		//simple pause
		public function pauseToggle():void{
			if(stage.hasEventListener(Event.ENTER_FRAME)){
				stopEngine();
			}else{
				startEngine();
			}
		}
		//
		public function startEngine():void{
			stage.addEventListener(Event.ENTER_FRAME, runEngine);
			
		}
		//
		public function stopEngine():void{
			stage.removeEventListener(Event.ENTER_FRAME, runEngine);
			
		}
		//update positions on every frame.  
		//Checks if hero is in the MOVE_BUFFER, and move Hero.
		//else hero is at MOVE_BUFFER limit and map scrolls instead. 
		private function runEngine(evt) {
			//invoke emotion in hero
			hero.moveMe();
			/****************************************************/
			//TODO: change up|down logic to prevent over-scrolling
			//should be able to base off of left|right logic
			/****************************************************/
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
		
	}//end class
}//end package