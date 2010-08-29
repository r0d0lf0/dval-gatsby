package engine.actors.geoms {
    
    import engine.actors.Actor;
    import engine.actors.geoms.FountainPlatform;
    
    public class Fountain extends Actor {
        
        private var myPlatform = new FountainPlatform();
        private var myMask = new FountainMask();
        
        public function Fountain() {
            
        }
        
        override public function setup() {
            addChild(myMask);
            this.y = this.y - this.height;
            var maskHeight = this.height;
            addChild(myPlatform);
            // myPlatform.y = this.height - mask.height;
            myPlatform.mask = myMask;
        }
        
        override public function update():void {
            myPlatform.update();
        }
        
        override public function notify(subject:*):void {
            myPlatform.notify(subject);
        }
        
    }
    
}