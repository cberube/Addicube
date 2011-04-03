package com.wasabi.addicube.sound 
{
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
		
		public function bind(event : String, sound : Class) : void
		{
			if (this.soundmap[event] == null) this.soundmap[event] = new Array();
			this.soundmap[event].push(sound);
		}
		
		public function getSoundForEvent(event : String) : Class
		{
			var which : int;
			
			which = FlxU.randomInRange(0, this.soundmap[event].length);
			return this.soundmap[event][which];
		}
		
	}

}