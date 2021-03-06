package com.wasabi.addicube.sound 
{
	import adobe.utils.CustomActions;
	import flash.media.Sound;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class SoundTrack extends FlxObject
	{
		private static var instance : SoundTrack;
		
		private var beatDelay : Number;
		private var beatClock : Number;
		
		private var beatQueue : Array;
		
		private var soundObjects : Object;
		
		private var soundSets : Object;
		
		private var beatId : int;
		
		public function SoundTrack() 
		{
			this.beatQueue = new Array();
			this.beatClock = 0;
			this.beatDelay = 0.6 / 4.0;
			this.beatId = 0;
			
			this.soundSets = { };
			
			var soundSet : SoundSet;
			
			soundSet = new SoundSet();
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_0);
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_1);
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_2);
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_3);
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_4);
			soundSet.bind(SoundSet.EVENT_WALK, Notes.B_4_5);
			
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_0);
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_1);
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_2);
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_3);
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_4);
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.B_16_5);
			
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_0);
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_1);
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_2);
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_3);
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_4);
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.B_1_5);
			
			this.soundSets["balanced"] = soundSet;
			
			soundSet = new SoundSet();
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_0);
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_1);
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_2);
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_3);
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_4);
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.N_1_5);
			
			this.soundSets["neutral"] = soundSet;
		}
		
		public static function get currentInstance() : SoundTrack
		{
			if (SoundTrack.instance == null)
			{
				SoundTrack.instance = new SoundTrack();
			}
			
			return SoundTrack.instance;
		}
		
		public function enqueueSound(soundClass : Class, panPosition : Number = 0.5) : void
		{
			this.beatQueue.push(new SoundQueue(soundClass, panPosition));
		}
		
		public function enqueueEventSound(setName : String, eventName : String, panPosition : Number, beatId : int = -1, beatMod : int = 0) : int
		{
			if (beatId >= 0 && beatId == this.beatId) return this.beatId;
			if (beatMod > 0 && (this.beatId % beatMod) > 0) return -1;
			
			this.enqueueSound(this.soundSets[setName].getSoundForEvent(eventName), panPosition);
			
			return this.beatId;
		}
		
		override public function update():void 
		{
			var queue : SoundQueue;
			
			this.beatClock -= FlxG.elapsed;
			
			/*if (this.beatQueue.length == 0)
			{
				var soundClass : Class;
				
				soundClass = this.soundSets["balanced"].getSoundForEvent(SoundSet.EVENT_WALK);
				this.enqueueSound(soundClass);
			}*/
			
			if (this.beatClock <= 0.0)
			{
				this.beatClock = this.beatDelay;
				
				while (this.beatQueue.length > 0)
				{
					queue = this.beatQueue.pop();
					this.playSound(queue.soundClass, queue.panPosition);
				}
				
				this.beatId++;
				if (this.beatId > 1000) this.beatId = 0;
			}
			
			super.update();
		}
		
		private function playSound(soundClass : Class, panPosition : Number) : void
		{
			var sound : FlxSound;
			
			sound = new FlxSound();
			sound.loadEmbedded(soundClass);
			sound.pan = (panPosition * 2.0) - 1.0;
			sound.play();
		}
		
		public function get currentBeatId() : int
		{
			return this.beatId;
		}
	}

}