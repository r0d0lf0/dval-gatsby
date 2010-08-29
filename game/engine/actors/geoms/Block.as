﻿package engine.actors.geoms{
	
	import flash.display.DisplayObject;
	import engine.actors.Actor;
	import engine.IObserver;

	dynamic public class Block extends Actor {
		
		public function Block():void{
			super();
		}
		
		override public function notify(subject:*):void {
		    if(checkCollision(subject)) {
		        subject.collide(this);
		    }
		}
		
		override public function checkCollision(subject) {
		    if((subject.x + subject.collide_right) >= this.x && (subject.x + subject.collide_left) < this.x + this.width) { // if we're within a subjects width of the right sid
		        if(subject.y < (this.y + this.height) && (subject.y + subject.height) >= this.y) {
		            trace("collide!");
		            return true;
		        }
		    }
		}
		
		public function onHit(smackData:Object,characterObject:*):void{
			
			var dx = smackData.dx;
			var ox = smackData.ox;
			var dy = smackData.dy;
			var oy = smackData.oy;
			
			if(ox < oy){
				if(dx < 0){
					//right
					/************************************/
					//this is a good 'bouncy' surface
					//var t = characterObject.velx-ox;
					//characterObject.velx = 0-t;
					/************************************/
					characterObject.velx = 0;
					characterObject.x += (ox/2)+1;
				}
				else{
					//left
					/************************************/
					//this is a good 'bouncy' surface
					//var t = characterObject.velx-ox;
					//characterObject.velx = t;
					/************************************/
					characterObject.velx = 0;
					characterObject.x -= (ox/2)-1;
				}
			}
			else{
				if(dy < 0){
					//bottom
					characterObject.y = me.y+characterObject.height+this.height;
					characterObject.vely = 0;
				}
				else{
					//top
					characterObject.y = me.y;
					characterObject.vely = 0;
					characterObject.imon = true;
				}
			}
		}
	}
}