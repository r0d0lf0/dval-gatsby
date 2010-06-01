package engine.actors{
	
	import flash.display.DisplayObject;
	import engine.actors.MapObject;

	dynamic public class Cloud extends MapObject{
		
		public function Cloud(w=1,h=1,tex = null):void{
			super(w,h,tex);
		}
		public override function behave(smackData:Object,characterObject:*):void{
			
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
	}
}