package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.objects.GameObject;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class PetriDish extends GameObject
	{
		
		[Embed(source = '../../../../../assets/background.png')]
		private static const GFX_DISH : Class;
		
		public function PetriDish() 
		{
			super(0, 0, PetriDish.GFX_DISH);
		}
		
	}

}