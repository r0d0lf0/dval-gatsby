package engine.screens {
    
    import flash.display.MovieClip;
    import engine.Screen;
    import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import flash.utils.Timer;
    import flash.events.*;
    
    public class GameOver extends Screen {
        
        private var counter:Number = 0;
        private var soundDone = false;
        private var musicChannel;
        private var sound;
        
        public function GameOver() {
            updateStatus(ACTIVE);
            sound = new game_over_music();
            musicChannel = sound.play(0);
            musicChannel.addEventListener(Event.SOUND_COMPLETE, this.soundComplete);
        }
        
        public function soundComplete(e) {
            soundDone = true;
            musicChannel.removeEventListener(Event.SOUND_COMPLETE, this.soundComplete);
        }
        
        override public function update(evt = null):Boolean {
            if(soundDone) {
                updateStatus(GAME_OVER);
                return false;
            } else {
                return true;
            }
        }
        
    }
    
}