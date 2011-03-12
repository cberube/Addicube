package com.wasabi.addicube.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class PetriDishEdge extends FlxSprite
	{
		
		[Embed(source = '../../../../../assets/table.tool.00.png')]
		private static const GFX_DISH_EDGE_01 : Class;
		
		[Embed(source = '../../../../../assets/table.tool.01.png')]
		private static const GFX_DISH_EDGE_02 : Class;
		
		[Embed(source = '../../../../../assets/table.tool.02.png')]
		private static const GFX_DISH_EDGE_03 : Class;
		
		private var currentGraphicIndex : int;
		
		public function PetriDishEdge() 
		{
			this.setGraphic(1);
		}
		
		public function setGraphic(index : int) : void
		{
			if (index == this.currentGraphicIndex) return;
			
			if (index <= 1) this.loadGraphic(PetriDishEdge.GFX_DISH_EDGE_01);
			if (index == 2) this.loadGraphic(PetriDishEdge.GFX_DISH_EDGE_02);
			if (index == 3) this.loadGraphic(PetriDishEdge.GFX_DISH_EDGE_03);
			
			this.currentGraphicIndex = index;
		}
		
	}

}