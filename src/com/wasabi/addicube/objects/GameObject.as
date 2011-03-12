package com.wasabi.addicube.objects 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class GameObject extends FlxSprite
	{
		
		public function GameObject(x : int = 0, y : int = 0, simpleGraphic : Class = null) 
		{
			super(x, y, simpleGraphic);
		}
		
	}

}