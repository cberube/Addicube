package com.wasabi.addicube.ui 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class AddicubeButton extends FlxButton
	{
		
		[Embed(source = '../../../../../assets/ui/buttonOff.png')]
		public static const GFX_BUTTON_OFF : Class;
		
		[Embed(source = '../../../../../assets/ui/buttonOn.png')]
		public static const GFX_BUTTON_ON : Class;
		
		private var offSprite : FlxSprite;
		private var onSprite : FlxSprite;
		
		private var offText : FlxText;
		private var onText : FlxText;
		
		public function AddicubeButton(text : String, callback : Function, offImage : Class, onImage : Class = null, x : int = 0, y : int = 0) 
		{
			super(x, y, callback);
			
			this.offSprite = new FlxSprite(0, 0, offImage);
			this.onSprite = onImage == null ? null : new FlxSprite(0, 0, onImage);
			
			this.loadGraphic(this.offSprite, this.onSprite);
			
			if (text != null && text != "")
			{
				offText = new FlxText(3, 0, this.width - 6, text);
				offText.alignment = "center";
				offText.color = 0x888888;
				
				onText = new FlxText(3, 0, this.width - 6, text);
				onText.alignment = "center";
				onText.color = 0xFFFFFF;
				
				offText.size = onText.size = 16;
				offText.y = onText.y = this.height / 2 - offText.height / 2;
				
				this.loadText(offText, onText);
			}
		}
		
	}

}