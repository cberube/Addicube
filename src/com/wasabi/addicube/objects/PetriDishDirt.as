package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.states.PlayingState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class PetriDishDirt extends FlxGroup
	{
		
		[Embed(source = '../../../../../assets/table.dirt.01.png')]
		public static const DIRT_1 : Class;
		
		[Embed(source = '../../../../../assets/table.dirt.01.png')]
		public static const DIRT_2 : Class;
		
		[Embed(source = '../../../../../assets/table.dirt.03.png')]
		public static const DIRT_3 : Class;
		
		private var dirtLayers : Array;
		
		private var dirtinessPerLayer : Number;
		
		public function PetriDishDirt() 
		{
			var layer : FlxSprite;
			
			this.dirtLayers = new Array();
			
			layer = new FlxSprite(0, 0);
			layer.createGraphic(1, 1, 0x0);
			this.add(layer);
			this.dirtLayers.push(layer);
			
			layer = new FlxSprite(0, 0, PetriDishDirt.DIRT_1);			
			layer.alpha = 0.4;
			this.add(layer);
			this.dirtLayers.push(layer);
			
			layer = new FlxSprite(0, 0, PetriDishDirt.DIRT_2);			
			layer.alpha = 0.6;
			this.add(layer);
			this.dirtLayers.push(layer);
			
			layer = new FlxSprite(0, 0, PetriDishDirt.DIRT_3);
			layer.alpha = 0.8;
			this.add(layer);
			this.dirtLayers.push(layer);
			
			var i : int;
			
			for (i = 0; i < this.dirtLayers.length; i++)
			{
				this.dirtLayers[i].color = 0x754C24;
			}
			
			this.dirtinessPerLayer = PetriDish.MAX_DIRTINESS / this.dirtLayers.length;
		}
		
		override public function update():void 
		{
			super.update();
			
			var i : int;
			var solidLayer : int;
			
			/*solidLayer = int(PlayingState.instance.petriDish.dirtiness / this.dirtinessPerLayer);
			
			for (i = 0; i < this.dirtLayers.length; i++)
			{
				this.dirtLayers[i].visible = (i == solidLayer ? true : false);
			}*/
			
			var cubes : int = PlayingState.instance.maxLiveCubeCount;
			
			this.dirtLayers[1].visible = (cubes >= 6 && cubes < 12);
			this.dirtLayers[2].visible = (cubes >= 12 && cubes < 18);
			this.dirtLayers[3].visible = (cubes >= 18);
		}
		
	}

}