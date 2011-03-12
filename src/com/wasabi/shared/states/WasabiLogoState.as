package com.wasabi.shared.states 
{
	import org.flixel.*;
	import com.wasabi.tr.Main;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Charles Berube / The Wasabi Project
	 */
	public class WasabiLogoState extends FlxState
	{
		
		[Embed(source = '../assets/images/wasabiProjectLogo.png')]
		private static const GFX_LOGO : Class;
		
		private var background : FlxSprite;
		private var logo : FlxSprite;
		
		private var clock : Number;
		private var fadingOut : Boolean;
		
		private var waiting : Boolean = false;
		
		public function WasabiLogoState() 
		{
			Mouse.hide();
			
			FlxG.log(Main.TITLE + ": " + Main.COPYRIGHT);
			FlxG.log("Version: " + Main.VERSION);
			
			/*ApiSupport.create();
			
			if (ApiSupport.getInstance().checkHost() == false)
			{
				return;
			}*/

			this.background = new FlxSprite(0, 0);
			this.background.createGraphic(FlxG.width, FlxG.height, 0xFF985F3D);
			
			this.logo = new FlxSprite(0, 0, WasabiLogoState.GFX_LOGO);
			this.logo.x = FlxG.width / 2 - this.logo.width / 2;
			this.logo.y = FlxG.height / 2 - this.logo.height / 2;
			//this.logo.addAnimation("Exist", [ 0 ], 1, true);
			//this.logo.play("Exist");
			this.logo.alpha = 1;
			
			this.add(this.background);
			this.add(this.logo);
			
			this.clock = 0;
			this.fadingOut = false;
			
			FlxG.flash.start(0xFF000000, 0.5, null, true);
			
			this.background.visible = false;
			this.logo.visible = false;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (this.waiting)
			{
				if (FlxG.keys.justPressed("X"))
				{
					this.waiting = false;
				}
				
				return;
			}
			
			this.clock += FlxG.elapsed;
			
			if (!this.logo.visible) 
			{
				FlxG.flash.start(0xFF000000, 0.5, null, false);
				this.background.visible = true;
				this.logo.visible = true;
				this.waiting = false;
			}
			
			if (this.clock > 1.5 && !this.fadingOut)
			{
				FlxG.fade.start(0xFF000000, 0.5, this.logoFinished, true);
				this.fadingOut = true;
			}
		}
		
		private function logoFinished() : void
		{
			Main.wasabiLogoFinished();
		}
	}
	
}