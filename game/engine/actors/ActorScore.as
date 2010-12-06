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
		private var label1:TextField = new TextField();
		private var slideTimer:Timer;
		private var myFont:Font = new ScoreFont(); 
				
		public function ActorScore(score, x, y):void{
			super();
			this.score = score;
			label1.text = this.score;
			var myFormat = new TextFormat();
			myFormat.font = myFont.fontName;
			myFormat.size = 10;
			myFormat.color = 0xFFFFFF;
			label1.setTextFormat(myFormat);
			this.addChild(label1);
			label1.x = x;
			label1.y = y;
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