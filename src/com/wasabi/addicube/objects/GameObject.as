package com.wasabi.addicube.objects 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class GameObject extends FlxSprite
	{
		
		public function GameObject(x : int = 0, y : int = 0, gfx : Class = null) 
		{
			super(x, y, gfx);
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			
			this.flicker( -1);
		}
		
		public function get depth() : int
		{
			return this.y;
		}
		
		public function get center() : FlxPoint
		{
			return new FlxPoint(
				this.x + this.width / 2,
				this.y + this.height / 2
			);
		}
		
		public function set center(p : FlxPoint) : void
		{
			this.x = p.x - this.width / 2;
			this.y = p.y - this.height / 2;	
		}
		
	}
	
}