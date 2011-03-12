package com.wasabi.shared.effects 
{
	import org.flixel.FlxEmitter;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class WasabiEmitter extends FlxEmitter
	{
		
		public function WasabiEmitter(x : int, y : int) 
		{
			super(x, y);
		}
		
		protected function generateParticleStock(clazz : Class, count : int) : void
		{
			for (var i : int = 0; i < count; i++)
			{
				this.add(new clazz, true);
			}
		}
		
	}

}