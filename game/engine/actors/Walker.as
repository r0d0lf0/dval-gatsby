package engine.actors {

   import engine.actors.Animatable;
   
   public class Walker extends Animatable {
       
       public function Walker() {
           trace("mover created");
       }
       
       	private function land(observer):void {
		    this.vely = 0;
		    if(observer is FountainPlatform) {
		        this.y = (observer.y + observer.velocity) - this.height;
		    } else {
		        this.y = observer.y - this.height;
		    }
	        jumpCount = 0;
	        standFlag = true;
	        if(stuckTo != observer) {
	            stuckTo = observer;
	        }
		}
		
		private function depart(observer):void {
		    standFlag = false;
		    stuckTo = false;
		}
		
		private function checkRight(observer):Boolean {
		    if((this.x + this.collide_left) < observer.x + observer.width) { // if we're collided with the square's right side currently
		        if((this.x + this.collide_left) - this.velx >= observer.x + observer.width) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
		
		private function checkLeft(observer):Boolean {
		    if((this.x + this.collide_right) > observer.x) { // if we're collided with the block's left side currently
		        if((this.x + this.collide_right) - this.velx <= observer.x) { // and we hadn't collided in the previous frame
		            return true;
		        }
		    }
		    return false;
		}
       
   }
    
}
