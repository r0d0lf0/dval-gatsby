package engine { 
    
    public interface ISubject {
        
        function subscribeObserver(o:IObserver):void;
        function unsubscribeObserver(o:IObserver):void;
        function notifyObservers():void;
    }
    
}