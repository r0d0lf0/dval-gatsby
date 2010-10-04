package engine.actors.geoms {
	
	import flash.display.DisplayObject;
	import engine.actors.geoms.Geom;
	import engine.IObserver;
	import engine.actors.specials.Door;
	import engine.actors.player.Hero;

	public class KillBlock extends Geom {
	    
	    private var killFlag:Boolean = false;
		
		public function KillBlock():void{
			super();
		}
		
		public function behave(smackData:Object,characterObject:*):void{	
			var dy = smackData.dy;
			//only stop downward movement
			if(characterObject.y < me.y+(this.height/2)){
				if(dy > 0){
					characterObject.y = me.y;
					characterObject.vely = 0;
					characterObject.imon = true;
				}
			}
		}
		
		override public function notify(subject:*):void {
		    if(subject is Door) {
		        
		    } else {
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