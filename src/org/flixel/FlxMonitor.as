package org.flixel
{
	import flash.utils.getTimer;
	/**
	 * FlxMonitor is a simple class that aggregates and averages data.
	 * Flixel uses this to display the framerate and profiling data
	 * in the developer console.  It's nice for keeping track of
	 * things that might be changing too fast from frame to frame.
	 */
	public class FlxMonitor
	{
		/**
		 * Stores the requested size of the monitor array.
		 */
		protected var _size:uint;
		/**
		 * Keeps track of where we are in the array.
		 */
		protected var _itr:uint;
		/**
		 * An array to hold all the data we are averaging.
		 */
		protected var _data:Array;
		
		/**
		 * [Wasabi] The name of this monitor, for display purposes
		 */
		public var name:String;
		
		/**
		 * [Wasabi] The unit this monitor is using for it's values (also for display purposes)
		 */
		public var unit:String;
		
		/**
		 * [Wasabi] For internal timing
		 */
		private var mark:uint;
		
		/**
		 * Creates the monitor array and sets the size.
		 * 
		 * @param	Size	The desired size - more entries means a longer window of averaging.
		 * @param	Default	The default value of the entries in the array (0 by default).
		 */
		public function FlxMonitor(Size:uint,Default:Number=0,Name:String="custom work",Unit:String="ms")
		{
			_size = Size;
			if(_size <= 0)
				_size = 1;
			_itr = 0;
			_data = new Array(_size);
			for(var i:uint = 0; i < _size; i++)
				_data[i] = Default;
				
			name = Name;
			unit = Unit;
		}
		
		/**
		 * Adds an entry to the array of data.
		 * 
		 * @param	Data	The value you want to track and average.
		 */
		public function add(Data:Number):void
		{
			_data[_itr++] = Data;
			if(_itr >= _size)
				_itr = 0;
		}
		
		/**
		 * Averages the value of all the numbers in the monitor window.
		 * 
		 * @return	The average value of all the numbers in the monitor window.
		 */
		public function average():Number
		{
			var sum:Number = 0;
			for(var i:uint = 0; i < _size; i++)
				sum += _data[i];
			return sum/_size;
		}
		
		/**
		 * [Wasabi] Starts the internal timer
		 */
		public function startTiming():void
		{
			this.mark = getTimer();
		}
		
		/**
		 * [Wasabi] Stops the internal timer and adds the number of milliseconds
		 * elapse to this monitor's values
		 */
		public function stopTiming():void
		{
			this.add(getTimer() - this.mark);
		}
	}
}