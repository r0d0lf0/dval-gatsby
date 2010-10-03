package engine{
	
	import flash.display.MovieClip;
	
	public interface ISubject{
		
		function addObserver(subscriber):void;
		function isObserver(subscriber):Boolean;
		function removeObserver(subscriber):void;
		function notifyObservers():void;
		
	}//end interface
	
}//end Packeage