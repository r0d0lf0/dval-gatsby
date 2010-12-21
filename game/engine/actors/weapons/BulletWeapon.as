﻿package engine.actors.weapons {        import engine.IObserver;    import engine.actors.player.Hero;    import engine.actors.enemies.Enemy;    import engine.actors.geoms.*;    import flash.events.Event;    import engine.actors.Animatable;	import flash.media.Sound;	import flash.media.SoundChannel;        public class BulletWeapon extends Weapon implements IObserver {                private var throwDistance:int = 120;        private var velx:Number = 0;        private var vely:Number = 0;        private const MAX_VEL_X = 5;		private var bulletSound = new bullet_sound();				private var soundChannel;                public function BulletWeapon(owner) {            super(owner);			goingLeft = owner.goingLeft;        }        		override public function setup() {		    flySpeed = 1;		    damage = 1;		    		    myName = "BulletWeapon";            mySkin = "BulletWeaponSkin";		    		    tilesWide = 1;    		tilesTall = 1;		    collide_left = 2; // what pixel do we collide on on the left    		collide_right = 14; // what pixel do we collide on on the right    		    		startFrame = 0; // the first frame to loop on            endFrame = 0; // the final frame in the row            nowFrame = 0; // current frame in row            loopFrame = 0; // frame at which to loop            loopType = 0; // 0 loops, 1 bounces            loopRow = 0; // which row are we on            loopDir = 1; // loop forward (to the right) by default            speed = 2; // how many frames should go by before we advance			flySpeed = 2;    		if(goingLeft) {    		    velx = -flySpeed;    		} else {    		    velx = flySpeed;    		}						var soundChannel = bulletSound.play(0);			animate();		}				override public function notify(subject):void {		    if(subject is Hero) {		        if(checkCollision(subject)) {    	            subject.receiveDamage(this);    	            frameCount = frameDelay;                }		    }		}				public function fireBullet(goingLeft) {		    frameCount = 0;		    frameDelay = throwDistance;		}				override public function update():void {		    if(frameCount >= throwDistance) {		        frameCount = 0;		        myMap.removeFromMap(this);		    } else {		        frameCount++;		        if(frameCount > 90) {		            this.alpha = frameCount %2;		        }		    }		    if(velx > MAX_VEL_X) {		        velx = MAX_VEL_X;		    }		    		    this.x += velx;		    		    notifyObservers();			animate();   		}		    }}