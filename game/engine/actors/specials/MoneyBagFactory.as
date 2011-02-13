package engine.actors.specials {
    
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.utils.getDefinitionByName; //sometime, the things we learn...
    import controls.KeyMap;
    import engine.IObserver;
    import engine.ISubject;
    import engine.actors.Actor;
    import engine.actors.player.Hero;
    import engine.actors.specials.MoneyBag;

    dynamic public class MoneyBagFactory extends Actor {
	
	protected var triggered = false;
	protected var spawnX = 0;
	protected var spawnY = 0;
	protected var triggerDelay = 0; // number of frames we need to collide for it to trigger
	protected var triggerCounter = 0;
	protected var soundChannel;
	protected var moneybag_appear_sound = new moneybag_spawn_sound();
	protected var defaultWidth = 20;
	protected var defaultHeight = 20;
	
	public function MoneyBagFactory():void{
	    super();
	    this.alpha = 0;
	    this.height = defaultHeight;
	    this.width = defaultWidth;
	    trace("factory spawned " + this.width + " " + this.height);
	}
	
	public function setSpawnPoint(x, y) {
	    this.spawnX = x;
	    this.spawnY = y;
	}
	
	public function setTriggerDelay(newDelay) {
	    this.triggerDelay = newDelay;
	}
	
	override public function notify(subject:*):void {
	    if(subject is Hero && !triggered) {
		if(checkCollision(subject)) {
		    triggerCounter++;
		    if(triggerCounter >= triggerDelay) {
		        trace("Triggered!");
			soundChannel = moneybag_appear_sound.play(0);
		        spawnMoneyBag();
    		        triggered = true;
		    }
		}
	    }
	}
	
	private function spawnMoneyBag() {
	    myMap.spawnActor(new MoneyBag(), spawnX, spawnY);
	}
	
    }
}