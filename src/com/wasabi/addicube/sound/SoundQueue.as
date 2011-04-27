package com.wasabi.addicube.sound 
{
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class SoundQueue
	{
		
		public var soundClass : Class;
		public var panPosition : Number;
		
		public function SoundQueue(soundClass : Class, panPosition : Number) 
		{
			this.soundClass = soundClass;
			this.panPosition = panPosition;
		}
		
	}

}