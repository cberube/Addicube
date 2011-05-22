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
		
		private var leftQueue : Object;
		private var rightQueue : Object;
		private var centerQueue : Object;
		
		private var soundObjects : Object;
		
		private var soundSets : Object;
		
		private var beatId : int;
		
		public function SoundTrack() 
		{
			this.leftQueue = new Object();
			this.rightQueue = new Object();
			this.centerQueue = new Object();
			
			this.beatClock = 0;
			this.beatDelay = 0.6 / 4.0;
			this.beatId = 0;
			
			this.soundSets = { };
			
			var soundSet : SoundSet;
			
			soundSet = new SoundSet();
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 0));
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 1));
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 2));
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 3));
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 4));
			soundSet.bind(SoundSet.EVENT_WALK, Notes.noteId("b", 4, 5));
			
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 0));
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 1));
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 2));
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 3));
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 4));
			soundSet.bind(SoundSet.EVENT_CHEW, Notes.noteId("b", 16, 5));
			
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 0));
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 1));
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 2));
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 3));
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 4));
			soundSet.bind(SoundSet.EVENT_HOOVER, Notes.noteId("b", 1, 5));
			
			this.soundSets["balanced"] = soundSet;
			
			soundSet = new SoundSet();
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 0));
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 1));
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 2));
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 3));
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 4));
			soundSet.bind(SoundSet.EVENT_PROBE, Notes.noteId("b", 1, 5));
			
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
		
		public function enqueueEventSound(setName : String, eventName : String, panPosition : Number, beatId : int = -1, beatMod : int = 0) : int
		{
			if (beatId >= 0 && beatId == this.beatId) return this.beatId;
			if (beatMod > 0 && (this.beatId % beatMod) > 0) return -1;
			
			//	Turn the panning position into a left / center / right
			var queue : Object;
			var soundId : int;
			
			if (panPosition <= 0.33) queue = this.leftQueue;
			else if (panPosition >= 0.66) queue = this.rightQueue;
			else queue = this.centerQueue;
			
			soundId = this.soundSets[setName].getSoundIdForEvent(eventName);
			
			if (queue[soundId] == null)
			{
				queue[soundId] = 0.0;
			}
			
			queue[soundId] += 0.2;
			
			//this.beatQueue.push(this.soundSets[setName].getSoundForEvent(eventName, panPosition));
			
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
				
				//SoundBuffer.currentInstance.beat(this.beatQueue);
				
				/*
				while (this.beatQueue.length > 0)
				{
					queue = this.beatQueue.pop();
					this.playSound(queue.soundClass, queue.panPosition);
				}
				*/
				
				for (var soundIdL : * in this.leftQueue)
				{
					FlxG.log("Left " + soundIdL + ": " + this.leftQueue[soundIdL]);
				}
				for (var soundIdR : * in this.rightQueue)
				{
					FlxG.log("Right " + soundIdR + ": " + this.rightQueue[soundIdR]);
				}
				for (var soundIdC : * in this.centerQueue)
				{
					FlxG.log("Center " + soundIdC + ": " + this.centerQueue[soundIdC]);
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