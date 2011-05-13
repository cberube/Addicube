package com.wasabi.addicube.sound 
{
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class SoundQueue
	{
		
		public var soundIndex : uint;
		public var soundClass : Class;
		public var panPosition : Number;
		
		public function SoundQueue(soundIndex : uint, soundClass : Class, panPosition : Number) 
		{
			this.soundIndex = soundIndex;
			this.soundClass = soundClass;
			this.panPosition = panPosition;
		}
		
		public function toString() : String 
		{
			return this.soundIndex + ":" + this.panPosition.toFixed(2);
		}
	}

}