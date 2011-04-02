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
		//private static const WALK_A : Class;	
		//private static const WALK_B : Class;
		
		private static const SOUNDSET_WALK : int = 0;
		
		private static var instance : SoundTrack;
		
		private var beatDelay : Number;
		private var beatClock : Number;
		
		private var beatQueue : Array;
		
		private var soundObjects : Object;
		
		private var soundSets : Object =
		{
			0: [ /*SoundTrack.WALK_A, SoundTrack.WALK_B*/ null, null ]
		}
		
		public function SoundTrack() 
		{
			this.beatQueue = new Array();
			this.beatClock = 0;
			this.beatDelay = 0.6 / 4.0;
		}
		
		public static function get currentInstance() : SoundTrack
		{
			if (SoundTrack.instance == null)
			{
				SoundTrack.instance = new SoundTrack();
			}
			
			return SoundTrack.instance;
		}
		
		public function enqueueSound(setId : int) : void
		{
			this.beatQueue.push(setId);
		}
		
		override public function update():void 
		{
			this.beatClock -= FlxG.elapsed;
			
			if (this.beatClock <= 0.0)
			{
				FlxG.log("Beat");
				this.beatClock = this.beatDelay;
				
				while (this.beatQueue.length > 0)
				{
					this.playSoundFromSet(this.beatQueue.pop());
				}
			}
			
			super.update();
		}
		
		private function getSoundGroup(setId : int) : int
		{
			if (this.soundObjects[setId] == null)
			{
				this.soundObjects[setId] = new FlxGroup();
			}
			
			return this.soundObjects[setId];
		}
		
		private function playSoundFromSet(setId : int) : int
		{
			var which : int;
			var soundSet : Array;
			var soundGroup : FlxGroup;
			var sound : FlxSound;
			
			soundSet = this.soundSets[setId];
			
			which = FlxU.random() * soundSet.length;
			
			sound = new FlxSound();
			sound.loadEmbedded(soundSet[which]);
			sound.play();
			
			return which;
		}
	}

}