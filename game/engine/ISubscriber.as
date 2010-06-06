package engine{
	
	import flash.display.MovieClip;
	
	public interface ISubscriber{
		
		function addSubscription(target:MovieClip):void;
		function cancelSubscription(target:MovieClip):void;
		function update():void;
		
		
	}//end interface
	
}//end Packeage