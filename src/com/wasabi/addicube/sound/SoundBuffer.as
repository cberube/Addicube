package com.wasabi.addicube.sound 
{
	import flash.media.Sound;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class SoundBuffer
	{
		public static const MAX_EMPTY_COUNT : uint = 32767; 
		
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
		private var songData : ByteArray;
		private var beatData : Array;
		
		private var socket : Socket;
		
		public function SoundBuffer() 
		{
			this.emptyBeatCount = 0;
			this.songData = new ByteArray();
			this.beatData = new Array();
			
			//this.socket = new Socket();
			//this.socket.connect('127.0.0.1', 50000);
		}
		
		public function addBeatData(note : int, pan : Number, volume : Number) : void
		{
			var value : int;
			var p : int;
			var v : int;
			
			value = note & Notes.MASK_ALL_NOTE_DATA;
			
			if (pan < 0.33) p = 0;
			else if (pan > 0.66) p = 2;
			else p = 1;
			
			v = Math.floor(volume * 31);
			
			value |= p << Notes.SHIFT_PAN;
			value |= v << Notes.SHIFT_VOLUME;
			
			this.beatData.push(value);
		}
		
		public function beat() : void
		{
			if (this.beatData.length == 0)
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
				this.storeNotes();
			}
			
			this.beatData = new Array();
			//this.socket.flush();
		}
		
		private function storeEmptyBeats() : void
		{
			if (this.emptyBeatCount == 0) return;
			
			var data : int;
			
			data = Notes.MASK_SILENCE | (this.emptyBeatCount & SoundBuffer.MAX_EMPTY_COUNT);
			this.songData.writeShort(data);
			//this.socket.writeShort(data);
			this.emptyBeatCount = 0;
		}
		
		private function storeNotes() : void
		{
			var i : int;
			
			for (i = 0; i < this.beatData.length; i++)
			{
				//this.socket.writeShort(this.beatData[i]);
			}
		}
		
		public function saveSongData() : void
		{
			
		}
	}
	

}