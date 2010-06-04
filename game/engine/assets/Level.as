package engine.assets {
    
    import engine.assets.*;
    import engine.*;
    import engine.maps.*;
	import engine.actors.*;
	import engine.assets.*;
	import flash.geom.Point;
    
 
   // Levels are any GameAsset that uses a Hero to guide its li
   public class Level extends Asset implements IGameAsset {
       
       protected var hero:Hero;
       protected var maps:Array = new Array();
       protected var map:Map;
       protected var count = 0;
       
       // names of swfs that are game wide, should be moved to the Level class eventually
       private var start_screen = 'start_screen';  // MC to play at the start of the level
       private var success_screen = 'success_screen'; // MC to play upon player success
       private var death_screen = 'death_screen'; // MC to play on player death
       
       // think about how the death animations might work for the hero.  should they be applied
       // outside by some physics layer?  would this make different animations for different
       // deaths easier?
       
       // basic level defaults
       protected var hero_spawn:Point = new Point(0, 0);
       protected var map_offset:Point = new Point(0, 0);
       private const MOVE_BUFFER:int = 60;
	   protected var screenWidth:Number;
	   protected var screenHeight:Number;
	   
	   protected var current_time:Number = 0;
       
       public function Level(hero:Hero, ldr) {
           super(ldr);
           this.hero = hero;
           addChild(map);
           addChild(hero);
           hero.name = 'hero';
           map.name = 'map';
           trace("Level created.");
           status = "ACTIVE";
       }
       
       private function killHero() {
           
       }
       
       //load new stuff, start engine
	   private function createLevel():void{

			/*************** Hero display set up ************************/
			// by default, drop the hero at 0,0, otherwise at our hero_spawn
			if(hero_spawn == null){
				hero.x = 0; 
				hero.y = 0; 
			}else{
				hero.x = hero_spawn.x; 
				hero.y = hero_spawn.y; 
			}
			
			
			//assume we want to start the level 'looking right'
			hero.ldir = true;
			//try and prevent jump....(or find different command for entering the door)
			hero.imon = false;
			hero.vely = 0;

			/**************** Map display set up***********************/
			if(map_offset == null){
				map.x = 0; 
				map.y = 0; 
			}else{//
				map.x = map_offset.x; 
				map.y = map_offset.y; 
			}
			/**************** Level ***********************/
			//add all the pieces to the stage
			stage.addChild(map);
			stage.addChild(hero);
			//startEngine();
		}
       
       override public function update():Boolean {
            current_time++; // advance the tick clock
			hero.moveMe(); //invoke emotion in hero
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
		   
           if(current_time > 200) {
               status = "COMPLETE";
               return false;
           } else {
               return true;
               alert("things!");
           }
       }
       
       private function start():void {
           map = new Map();
           this.addChild(map);
       }
       
       private function run():Boolean {
           return true;
       }
       
       private function complete():Boolean {
           return true;
       }
       
       private function onKeyPress(e) {
           
           
           // create loop for how to move the Hero around here
           //hero.controlUpdate(e);  // send keypress events to the Hero
       }

   }
    
}