package engine.actors.weapons{

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.events.Event;

	public class Weapon extends Sprite {
		
		public var wSpeed:Number = 11.3;
		public var wPower:int = 1;
		private var wTile:int = 8;
		//private var weaponSkin:WeaponSkins = new WeaponSkins(0,0); //automatically imported from gatsby.fla
		public var weaponData:WeaponSkins = new WeaponSkins(0,0);
		public var atk:Sprite = new Sprite();

		//make hat from existing texture resource
		public function Weapon(pwr:int=0):void{
			//var p:Point = localToGlobal(new Point(0,-32));
			var hatCopy = new Rectangle(pwr*wTile,0,16,8);
			var hatBytes = weaponData.getPixels(hatCopy);
			hatBytes.position = 0;
			var hatPaste:Rectangle = new Rectangle(0,0,16,8); //paste
			var displayHat:BitmapData  = new BitmapData(16,8,true,0x00000000);
			displayHat.setPixels(hatPaste,hatBytes);
			var hat:Bitmap = new Bitmap(displayHat);
			//hat.scaleX = 2;
			//hat.scaleY = 2;
			atk.addChild(hat);
		}
		public function useWeapon(ldir:Boolean):void{
			//add weapon attack
			var t = stage.getChildByName('map');
			var h = stage.getChildByName('hero');
			/******************************************************
			/*@TODO: this is the section that is broken:  
			/* "h = new hat()"   needs to be transposed to  "this"
			/* so h.x  becomes this.x and so on.
			/*
			/* also:
			/* velx and vely are from hero. you could just substitute 14;
			/******************************************************
			var h = hat();*/
			atk.x = h.x-14;
			atk.y = h.y+14;
			if(ldir){
				atk.addEventListener(Event.ENTER_FRAME,rtFrm);
			}else{
				atk.addEventListener(Event.ENTER_FRAME,ltFrm);
			}
			atk.addEventListener(Event.REMOVED_FROM_STAGE,htRemove);
			trace('added to '+t);
			t.addChild(atk);
		}
		//shoot right
		private function rtFrm(evt:Event):void{
			trace('tick right' + atk.x);
			evt.target.x += 11;
		}
		//shoot left
		private function ltFrm(evt:Event):void{
			trace('tick left');
			evt.target.x -= 11;
		}
		//free resorces at end of hat
		private function htRemove(evt:Event):void{
			try{
				evt.target.removeEventListener(Event.ENTER_FRAME,rtFrm);
			}finally{
				evt.target.removeEventListener(Event.ENTER_FRAME,ltFrm);
			}
			evt.target.removeEventListener(Event.REMOVED_FROM_STAGE,htRemove);
		}
	}//end class
}//end package