package engine.actors.enemies {
    
   
    
    public class EnemyWalker extends Enemy {
        
        public function EnemyWalker() {
            trace("Enemy Walker Created.");
		    this.y -= this.height; // bring waiters up to flo
        }
        
    }
    
}