package engine.physics {
	
	public class Physics{
		
		static public var friction:Number = 2.0;
		static public var gravity:Number = 2.0;
		
		static public function tick(ob:Object):void {
		    // velocitize y (gravity)
			if (ob.vely < MAX_VEL_Y) {
				ob.vely += gravity;
			}
			
			// de-velocitize x (friction)
			if (ob.velx > 0) {
				ob.velx -= friction;
			} else if (ob.velx < 0) {
				ob.velx += friction;
			}
		}
		
	}//end class
}//end package