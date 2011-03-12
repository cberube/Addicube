package com.wasabi.addicube 
{
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class Utility 
	{
		
		public function Utility() 
		{
			
		}
		
		public static function DegreesToRadians(d : Number) : Number
		{
			return (d / 180) * Math.PI;
		}
		
		public static function RadiansToDegrees(r : Number) : Number
		{
			return (r / Math.PI) * 180;
		}
		
	}
	
}