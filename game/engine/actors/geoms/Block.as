package engine.actors.geoms{
	
	import flash.display.DisplayObject;
	import engine.actors.geoms.Geom;
	import engine.IObserver;

	dynamic public class Block extends Geom {
		
		public function Block():void{
			super();
		}
		
		override public function checkCollision(subject) {
		    if((subject.x + subject.collide_right_ground) >= this.x && (subject.x + subject.collide_left_ground) < this.x + this.width) { // if we're within a subjects width of the right side
		        if(subject.y < (this.y + this.height) && (subject.y + subject.height) >= this.y) {
		            return true;
		        }
		    }
		}
	}
}