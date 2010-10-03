package engine.actors.weapons{

    import engine.actors.Animatable;
    import engine.actors.Actor;
    
	public class Weapon extends Animatable {
	    
        public var owner:Actor;
	    public var damage:Number = 1;
	    protected var frameCount:Number = 0;
        protected var frameDelay:Number = 2;
        protected var flySpeed:Number = 7;
		
        public function Weapon(owner) {
            this.owner = owner;
        }
        
        public function setOwner(owner) {
		    this.owner = owner;
		}
	}//end class
}//end package