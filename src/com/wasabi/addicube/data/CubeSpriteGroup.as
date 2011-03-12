package com.wasabi.addicube.data 
{
	import com.wasabi.addicube.objects.Cube;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class CubeSpriteGroup extends FlxGroup
	{
		
		public var cube : Cube;
		
		public function CubeSpriteGroup(c : Cube) 
		{
			this.cube = c;
		}
		
		public function get depth() : int
		{
			return this.cube.bodyCollider.top;
		}
		
	}

}