package engine.actors{
	
	import flash.display.DisplayObject;
	import engine.actors.MapObject;

	dynamic public class Block extends MapObject{
		
		public function Block(w=1,h=1,tex = null):void{
			super(w,h,tex);
		}
		public override function behave(characterObject):void{
			// and if there is a foot up...
			//trace(this.y+":"+this.height);
			// and if there is a foot up...
			//if (characterObject.y+characterObject.height < this.y+(this.height/2)+map.y) {
				//trace(objectArray[obj].name+' whack');
				// stop moving down
				characterObject.vely = 0;
				// place on the ground
				//characterObject.imon = true;
				characterObject.ihit = true;
				// puts the character on the ground and adds a 1 pixel contact buffer
				// allows smoothwr use of moving platformses
				//characterObject.y = (this.y+map.y)-characterObject.height+1;
				characterObject.y = this.y;
			//}
		}
	}
}