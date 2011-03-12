package com.wasabi.addicube.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class CubeBodyCollider extends FlxSprite
	{
		
		public var cube : Cube;
		
		public function CubeBodyCollider(x : int, y : int, gfx : Class) 
		{
			super(x, y, gfx);
		}
		
	}

}