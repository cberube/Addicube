package com.wasabi.shared 
{
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class WasabiU
	{
		
		public function WasabiU() 
		{
		}
		
		public static function dumpObject(o : *, indent : String = "\t") : String
		{
			var d : String = "";
			var k : String;
			
			d = "" + o.toString();
			for (k in o)
			{
				d = d + "\n" + indent + k + ": " + dumpObject(o[k], indent + "\t");
			}
			
			return d;
		}
		
		public static function loadString(source : Class) : String
		{
			var string : String;
			
			string = new source();
			string = string.replace(/\r\n/g, "\n");
			
			return string;
		}
		
		public static function copyArray(source : Array, target : Array) : Array
		{
			var i : int;
			
			for (i = 0; i < source.length; i++)
			{
				target.push(source[i]);
			}
			
			return target;
		}
		
		public static function createArrayCopy(source : Array) : Array
		{
			return WasabiU.copyArray(source, new Array());
		}
		
		public static function fillArrayWithObjects(array : Array, clazz : Class, count : int = -1) : void
		{
			var i : int;
			
			if (count < 0) count = (array == null ? 0 : array.length);
			
			for (i = 0; i < count; i++) array[i] = new clazz;
		}
	}

}