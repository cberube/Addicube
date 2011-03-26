package com.wasabi.addicube.utility 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class FadeSprite extends FlxSprite
	{
		
		private var t : Number;
		
		private var startIn : Number;
		private var solidTime : Number
		private var startOut : Number;
		private var hidden : Number;
		
		public var url : String;
		
		public var hasBeenClicked : Boolean;
		
		public function FadeSprite(x : int, y : int, gfx : Class) 
		{
			super(x, y, gfx);
			this.url = null;
			this.hasBeenClicked = false;
		}
		
		public function start(si : Number, s : Number, so : Number, h : Number) : void
		{
			this.startIn = si;
			this.solidTime = s;
			this.startOut = so;
			this.hidden = h;
			this.t = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			var d : Number;
			var p : Number;
			
			this.t += FlxG.elapsed;
			
			if (this.t < this.startIn)
			{
				this.alpha = 0;
			}
			else if (this.t < this.solidTime)
			{
				d = this.solidTime - this.startIn;
				p = this.t - this.startIn;
				
				p = p / d;
				
				this.alpha = p;
			}
			else if (this.t < this.startOut)
			{
				this.alpha = 1.0;
			}
			else if (this.t < this.hidden)
			{
				d = this.hidden - this.startOut;
				p = this.t - this.startOut;
				
				p = p / d;
				
				this.alpha = 1.0 - p;
			}
			else
			{
				this.kill();
			}
		}
		
	}

}