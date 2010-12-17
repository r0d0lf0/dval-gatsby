package engine.actors.geoms {
	
	import flash.display.DisplayObject;
	import engine.actors.geoms.Geom;
	import engine.IObserver;
	import engine.actors.specials.Door;
	import engine.actors.player.Hero;

	public class Cloud extends Geom {
		
		public function Cloud():void{
			super();
		}
		
		override public function notify(subject:*):void {
		    if(subject is Door) {
		        
		    } else {
		        if((subject.y + subject.height) >= this.y && subject.y <= (this.y+this.height)) {
    		        if((subject.x + subject.collide_right) >= this.x && (subject.x + subject.collide_left) <= (this.x+this.width)) {
    		            subject.collide(this);
    		        }
    		    }
		    }
		}
	}
}