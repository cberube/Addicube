package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.states.PlayingState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class PetriDish extends GameObject
	{
		
		[Embed(source = '../../../../../assets/table.lower.00.png')]
		public static const GFX_PETRI_DISH_BASE : Class;
		
		public static const MAX_DIRTINESS : Number = 20.0;
		private static const DIRTINESS_PER_CUBE : Number = 0.05;
		
		private var base : FlxSprite;
		private var dirt : FlxSprite;
		
		//public var dirtiness : Number;
		
		public function PetriDish() 
		{
			super(0, 0, PetriDish.GFX_PETRI_DISH_BASE);
		}
		
		public function get dirtiness() : Number
		{
			var cubes : int = PlayingState.instance.maxLiveCubeCount;
			
			if (cubes >= 6 && cubes < 12) return 1;
			else if (cubes >= 12 && cubes < 18) return 2;
			else if (cubes >= 18) return 3;
			
			return 3;
		}
		
	}

}