package engine.actors {
		
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName; //sometime, the things we learn...
	import controls.KeyMap;
	import engine.IObserver;
	import engine.ISubject;
	import engine.actors.Actor;
	import engine.actors.player.Hero;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;

	dynamic public class ActorScore extends Actor {
		
		private var score = "";
		private var lifeCounter = 0;
		private const lifeDuration = 20;
		private var label1Container = new ScorePopupContainer();
		private var slideTimer:Timer;
        private var label1;
				
		public function ActorScore(score, x, y):void{
			super();
			this.score = score;
			label1 = label1Container.getChildByName('ScorePopupField');
			label1.text = score;
			label1.x = x;
			label1.y = y;
			this.addChild(label1);
		}
		
		override public function setup() {
			slideTimer = new Timer(33);
            slideTimer.addEventListener(TimerEvent.TIMER, this.slideUp);
			slideTimer.start();
		}
		
		public function slideUp(evt):void {
			this.y--;
			lifeCounter++;
			if(lifeCounter > lifeDuration) {
				slideTimer.removeEventListener(TimerEvent.TIMER, this.slideUp);
				slideTimer.stop();
				myMap.removeFromMap(this);
			}
		}
		
		override public function update():void {

		}
		
	}
}