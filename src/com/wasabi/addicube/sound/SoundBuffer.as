package com.wasabi.addicube.sound 
{
	import flash.media.Sound;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class SoundBuffer
	{
		private static const MAX_EMPTY_COUNT : uint = 1024 * 32; 
		
		private static var instance : SoundBuffer;
		
		public static function get currentInstance() : SoundBuffer
		{
			if (SoundBuffer.instance == null)
			{
				SoundBuffer.instance = new SoundBuffer();
			}
			
			return SoundBuffer.instance;
		}
		
		private var emptyBeatCount : uint;
		private var songData : Array;
		
		public function SoundBuffer() 
		{
			this.emptyBeatCount = 0;
			this.songData = new Array();
		}
		
		public function beat(content : Array = null) : void
		{
			if (content == null || content.length == 0)
			{
				this.emptyBeatCount++;
				
				if (this.emptyBeatCount >= SoundBuffer.MAX_EMPTY_COUNT)
				{
					this.storeEmptyBeats();
				}
			}
			else
			{
				this.storeEmptyBeats();
				
				this.songData.push(content.join(','));
				FlxG.log(this.songData[this.songData.length - 1]);
			}
		}
		
		private function storeEmptyBeats() : void
		{
			if (this.emptyBeatCount > 0)
			{
				this.songData.push(this.emptyBeatCount + ",-");
				this.emptyBeatCount = 0;
				FlxG.log(this.songData[this.songData.length - 1]);
			}
		}
	}
	

}