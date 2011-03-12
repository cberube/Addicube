package com.wasabi.addicube.objects 
{
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class PetriDishRim extends GameObject
	{
		
		[Embed(source = '../../../../../assets/table.top.00.png')]
		private static const GFX_PETRI_DISH_RIM : Class;
		
		public function PetriDishRim() 
		{
			this.loadGraphic(PetriDishRim.GFX_PETRI_DISH_RIM);
		}
		
	}

}