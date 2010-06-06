package engine{
	
	import flash.display.MovieClip;
	
	dynamic public class Subscriber{
		
		static public var subscriptions:Array = new Array();
		
		
		//add item to list
		static function addSubscription(target:MovieClip):void{
			subscriptions.push(target);
		};
		
		//removes item form array via copy/rebuild
		static function cancelSubscription(target:MovieClip):void{
			var tmp:Array = new Array();
			for (var i:int=0; i<subscriptions.length; i++){
				if(subscriptions[i] != target){
					tmp.push(subscriptions[i]);
				}
			}
			subscriptions = tmp;
		};
		
		
	}//end interface
	
}//end Packeage