package com.wasabi.addicube.data 
{
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class CubeState 
	{
		
		//	Doing nothing
		public static const IDLE : int = 0;
		public static const IDLE_STUNNED : int = 10;
		public static const IDLE_MOPING : int = 20;
		public static const IDLE_CONFUSED : int = 30;
		
		//	Eating
		public static const EATING_START : int = 100;
		public static const EATING_HOOVER : int = 110;
		public static const EATING_CHEW : int = 120;
		
		//	States the imply movement towards a target point
		public static const MOVING : int = 200;
		public static const MOVING_TO_FOOD : int = 210;
		public static const CHARGING : int = 300;
		
		//	States that imply movement towards a target object
		public static const CHASING : int = 400;
		public static const HEAD_BUTTING : int = 410;
		
		//	Moves towards the least populated area of the dish
		public static const AVOIDING_OTHERS : int = 600;
		
		public function CubeState() 
		{
			
		}
		
	}
	
}