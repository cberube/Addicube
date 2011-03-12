package com.wasabi.shared.ui 
{
	import com.wasabi.addicube.ui.AddicubeButton;
	import com.wasabi.addicube.ui.TutorialButton;
	import com.wasabi.shared.ui.Frame;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class TextFrame extends Frame
	{
		
		[Embed(source = '../../../../../assets/ui/okayButton.png')]
		private static const GFX_OKAY_BUTTON_UP : Class;
		
		[Embed(source = '../../../../../assets/ui/okayButton.mouseOver.png')]
		private static const GFX_OKAY_BUTTON_OVER : Class;
		
		[Embed(source = '../../../../../assets/ui/okayButton.mouseDown.png')]
		private static const GFX_OKAY_BUTTON_DOWN : Class;
		
		[Embed(source = '../../../../../assets/ui/skipButton.png')]
		private static const GFX_SKIP_BUTTON_UP : Class;
		
		[Embed(source = '../../../../../assets/ui/skipButton.mouseDown.png')]
		private static const GFX_SKIP_BUTTON_DOWN : Class;
		
		[Embed(source = '../../../../../assets/ui/skipButton.mouseOver.png')]
		private static const GFX_SKIP_BUTTON_OVER : Class;
		
		public var textDisplay : FlxText;
		
		private var text : String;
		
		private var okButton : TutorialButton;
		private var skipButton : TutorialButton;
		
		public var okCallback : Function;
		public var skipCallback : Function;
		
		private var iconPadding : int = 50;
		
		public function TextFrame(frameGraphic : Class, text : String = "", partSize : int = 0) 
		{
			super(frameGraphic, partSize);
			
			this.okCallback = null;
			this.skipCallback = null;
			
			this.text = text;			
			this.textDisplay = new FlxText(
				this.framePartSize / 2,
				this.framePartSize / 2, 50, this.text);
			this.textDisplay.size = 12;
			this.textDisplay.color = 0x0;
			//this.textDisplay.shadow = 0xE0E0E0;
			this.add(this.textDisplay);
			
			this.okButton = new TutorialButton(0, 0, TextFrame.GFX_OKAY_BUTTON_UP, TextFrame.GFX_OKAY_BUTTON_OVER, TextFrame.GFX_OKAY_BUTTON_DOWN, this.onOk);
			//this.okButton.loadText(new FlxText(0, 0, 20, "OK"));
			this.add(this.okButton);
			
			this.skipButton = new TutorialButton(0, 0, TextFrame.GFX_SKIP_BUTTON_UP, TextFrame.GFX_SKIP_BUTTON_OVER, TextFrame.GFX_SKIP_BUTTON_DOWN, this.onSkip);
			//this.skipButton.loadText(new FlxText(0, 0, 50, "Skip"));
			this.add(this.skipButton);
		}
		
		public function setSkipButtonVisible(v : Boolean) : void
		{
			this.skipButton.visible = this.skipButton.exists = v;
		}
		
		private function onOk() : void
		{
			if (this.okCallback != null)
			{
				this.okCallback();
			}
		}
		
		private function onSkip() : void
		{
			if (this.skipCallback != null)
			{
				this.skipCallback();
			}
		}
		
		override public function setSize(w:int, h:int):void 
		{
			super.setSize(w, h);
			
			this.textDisplay.width = w - framePartSize - iconPadding;
			
			this.okButton.x = w - this.okButton.width - framePartSize;
			this.okButton.y = h - this.okButton.height - framePartSize;
			
			this.skipButton.x = this.okButton.x - this.skipButton.width - 2;
			this.skipButton.y = this.okButton.y;
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			
			this.okButton.x = this.x + this.width - this.okButton.width - 20;
			this.okButton.y = this.y + this.height - this.okButton.height - 10;
			
			this.skipButton.x = this.okButton.x - this.skipButton.width - 2;
			this.skipButton.y = this.okButton.y;
		}
		
		public function setSizeAndText(w:int, t:String) : void
		{
			this.text = t;
			this.textDisplay.changeWidth(w - framePartSize - iconPadding);
			this.textDisplay.text = this.text;
			
			this.setSize(
				textDisplay.width + framePartSize + iconPadding,
				this.textDisplay.height + framePartSize + this.okButton.height
			);
		}
		
		override public function setScrollFactor(sf:FlxPoint):void 
		{
			super.setScrollFactor(sf);
			
			this.okButton.scrollFactor.x = sf.x;
			this.okButton.scrollFactor.y = sf.y;
			
			this.skipButton.scrollFactor.x = sf.x;
			this.skipButton.scrollFactor.y = sf.y;
		}
	}

}