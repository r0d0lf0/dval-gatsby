package engine.actors.geoms {
	
	import flash.display.DisplayObject;
	import engine.actors.geoms.Geom;
	import engine.IObserver;
	import engine.actors.specials.Door;
	import engine.actors.player.Hero;

	public class KillBlock extends Geom {
	    
	    private var killFlag:Boolean = false;
		public var damage:Number = 100;
		
		public function KillBlock():void{
			super();
		}
		
		override public function notify(subject:*):void {
		    if(subject is Hero) {
		        if((subject.y + subject.height) >= this.y && subject.y <= (this.y+this.height)) {
    		        if((subject.x + subject.collide_right) >= this.x && (subject.x + subject.collide_left) <= (this.x+this.width)) {
    		            if(!killFlag) {
    		                subject.collide(this);
    		                killFlag = true;
    		            }
    		        }
    		    }
		    }
		}
	}
}