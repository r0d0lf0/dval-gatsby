package engine.actors.geoms {
	
	import flash.display.DisplayObject;
	import engine.actors.MapObject;
	import engine.actors.Actor;
	import engine.IObserver;

	public class Cloud extends Actor implements IObserver {
		
		public function Cloud():void{
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
		
		public function notify(subject:*):void {
		    if(subject.y >= this.y && subject.y <= (this.y+this.height)) {
		        if(subject.x >= this.x && subject.x <= (this.x+this.width)) {
		            subject.collide(this);
		        }
		    }
		}
	}
}