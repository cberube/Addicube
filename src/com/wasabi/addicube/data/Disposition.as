package com.wasabi.addicube.data 
{
	
	/**
	 * Describes behavioral constants for various cube dispositions
	 * @author Charles Berube
	 */
	public class Disposition 
	{
		
		//	Cube dispositions
		public static const BALANCED : int = 0;
		public static const RED : int = 1;
		public static const GREEN : int = 2;
		public static const BLUE : int = 3;
		public static const YELLOW : int = 4;
		public static const MAGENTA : int = 5;
		public static const CYAN : int = 6;
		
		public static const DEBUG_FACE_MOUSE : int = 100;
		
		public static const TINT_COLOR : Array =
		[
			0xFFFFFF,
			0xFF0000,
			0x00DD00,
			0x0000FF,
			0xEEEE00,
			0xEE00EE,
			0x00EEEE
		];
		
		public function Disposition() 
		{
			
		}
		
	}
	
}