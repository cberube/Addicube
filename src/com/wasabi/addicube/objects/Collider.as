package com.wasabi.addicube.objects 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Collider extends FlxSprite
	{
		
		private var currentOwner : FlxObject;
		
		public function Collider(o : FlxObject) 
		{
			this.currentOwner = o;
		}
		
		public function get owner() : FlxObject
		{
			return this.currentOwner;
		}
		
	}

}