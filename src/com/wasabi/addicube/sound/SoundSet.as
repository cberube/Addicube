package com.wasabi.addicube.sound 
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class SoundSet
	{
		
		public static const EVENT_WALK : String = "walk";
		public static const EVENT_HOOVER : String = "hoover";
		public static const EVENT_CHEW : String = "chew";
		
		public static const EVENT_PROBE : String = "probe";
		
		private var soundmap : Object;
		
		public function SoundSet() 
		{
			this.soundmap = { };
		}
		
		public function bind(event : String, soundId : int) : void
		{
			if (this.soundmap[event] == null) this.soundmap[event] = new Array();
			this.soundmap[event].push(soundId);
		}
		
		public function getSoundIdForEvent(event : String) : int
		{
			var which : int;
			var note : Class;
			
			which = FlxU.randomInRange(0, this.soundmap[event].length);
			
			which = this.soundmap[event][which];
			return which;
		}
		
		public function getSoundForEvent(event : String, pan : Number = 0.0) : SoundQueue
		{
			var which : int;
			var note : Class;
			
			which = FlxU.randomInRange(0, this.soundmap[event].length);
			
			which = this.soundmap[event][which];
			note = Notes.soundMap[which];
			
			return new SoundQueue(which, note, pan);
		}
		
	}

}