package org.flixel
{
	/**
	 * Stores a 2D floating point coordinate.
	 */
	public class FlxPoint
	{
		/**
		 * @default 0
		 */
		public var x:Number;
		/**
		 * @default 0
		 */
		public var y:Number;
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function FlxPoint(X:Number=0, Y:Number=0)
		{
			x = X;
			y = Y;
		}
		
		/**
		 * Convert object to readable string name.  Useful for debugging, save games, etc.
		 */
		public function toString():String
		{
			return FlxU.getClassName(this,true) + "[" + this.x + ", " + this.y + "]";
		}
		
		/**
		 * Computes the linear interpolation between two points 
		 */
		public static function lerp(a : FlxPoint, b : FlxPoint, amount : Number) : FlxPoint
		{
			var result : FlxPoint;
			
			result = new FlxPoint(
				a.x + (b.x - a.x) * amount,
				a.y - (b.y - a.y) * amount
			);
			
			return result;
		}
		
		public function length() : Number
		{
			return Math.sqrt((this.x * this.x) + (this.y * this.y));
		}
		
		public static function distance(a : FlxPoint, b : FlxPoint) : Number
		{
			return Math.sqrt(
				(a.x - b.x) * (a.x - b.x) +
				(a.y - b.y) * (a.y - b.y)
			);
		}
		
		public static function normalize(p : FlxPoint) : FlxPoint
		{
			var pn : FlxPoint;
			var d : Number;
			
			d = (p.x * p.x) + (p.y * p.y);
			if (d == 0) return p;
			
			d = Math.sqrt(d);
			pn = new FlxPoint(p.x / d, p.y / d);
			return pn;
		}
		
		public static function normalizeWithDistance(p : FlxPoint, d : Number) : FlxPoint
		{
			var pn : FlxPoint;
			
			if (d == 0) return p;
			pn = new FlxPoint(p.x / d, p.y / d);
			return pn;
		}
	}
}