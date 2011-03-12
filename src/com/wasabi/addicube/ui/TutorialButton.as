package com.wasabi.addicube.ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class TutorialButton extends FlxSprite
	{
		
		private var upImage : Class;
		private var overImage : Class;
		private var downImage : Class;
		
		private var callback : Function;
		
		public function TutorialButton(x : int, y : int, gfxUp : Class, gfxOver : Class, gfxDown : Class, cb : Function = null) 
		{
			super(x, y, gfxUp);
			
			this.upImage = gfxUp;
			this.overImage = gfxOver;
			this.downImage = gfxDown;
			
			this.callback = cb;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (this.overlapsPointScreenspace(FlxG.mouse.screenX, FlxG.mouse.screenY))
			{
				this.loadGraphic(FlxG.mouse.pressed() ? this.downImage : this.overImage);
			}
			else
			{
				this.loadGraphic(this.upImage);
			}
			
			if (
				this.callback != null &&
				FlxG.mouse.justPressed() &&
				this.overlapsPointScreenspace(FlxG.mouse.screenX, FlxG.mouse.screenY)
			)
			{
				this.callback();
			}
		}
		
	}

}