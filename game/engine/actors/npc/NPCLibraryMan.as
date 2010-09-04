package engine.actors.npc {
    
    import engine.actors.npc.NPC;
    
    public class NPCLibraryMan extends NPC {
        
       protected var dialogBox = new DialogBox();
        
       public function LibraryMan() {
           // welcome, friend
       }
       
       override public function update():void {
           
       }
       
       override public function collisionAction() {
           this.addChild(dialogBox);
           dialogBox.y = -100;
           dialogBox.start();
       }
        
    }
    
}