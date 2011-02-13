package engine.actors.geoms{
	
	import flash.display.DisplayObject;
	import engine.actors.geoms.Geom;
	import engine.IObserver;

	dynamic public class Block extends Geom {
		
		public function Block():void{
			super();
			
			collide_right = this.width;
			collide_left = 0;
		}
	}
}