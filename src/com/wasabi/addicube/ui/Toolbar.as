package com.wasabi.addicube.ui 
{
	import com.wasabi.addicube.Main;
	import com.wasabi.addicube.states.PlayingState;
	import org.flixel.data.FlxPanel;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Toolbar extends FlxGroup
	{
		
		[Embed(source = '../../../../../assets/menu.base.png')]
		private static const GFX_TOOLBAR_BASE : Class;
		
		[Embed(source = '../../../../../assets/button.00.png')]
		private static const GFX_TOOLBAR_BUTTON_PAN : Class;
		
		[Embed(source = '../../../../../assets/button.01.png')]
		private static const GFX_TOOLBAR_BUTTON_PROBE : Class;
		
		[Embed(source = '../../../../../assets/button.02.png')]
		private static const GFX_TOOLBAR_BUTTON_PIPETTE : Class;
		
		[Embed(source = '../../../../../assets/button.03.png')]
		private static const GFX_TOOLBAR_BUTTON_TWEEZERS : Class;
		
		[Embed(source = '../../../../../assets/button.04.png')]
		private static const GFX_TOOLBAR_BUTTON_SCALPEL : Class;
		
		public static const BUTTON_PAN : int = 0;
		public static const BUTTON_PROBE : int = 1;
		public static const BUTTON_PIPETTE : int = 2;
		public static const BUTTON_TWEEZERS : int = 3;
		public static const BUTTON_SCALPEL : int = 4;
		
		private var firstButtonOffset : FlxPoint = new FlxPoint(219, 0);
		private var buttonSpacing : int = 11;
		
		private var backgroundSprite : FlxSprite;
		private var buttons : Array;
		
		private var pauseButton : FlxSprite;
		
		public function Toolbar() 
		{
			var i : int;
			var x : int;
			var y : int;
			
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
			
			//	Background
			this.backgroundSprite = new FlxSprite(0, 0, Toolbar.GFX_TOOLBAR_BASE);
			this.add(this.backgroundSprite, true);
			
			//	Buttons
			this.buttons = new Array();
			
			x = this.firstButtonOffset.x;
			y = this.firstButtonOffset.y;
			
			this.buttons.push(new ToolbarButton(x, y, Toolbar.GFX_TOOLBAR_BUTTON_PAN, this.buttonPressed, Toolbar.BUTTON_PAN));
			x += ToolbarButton.WIDTH + this.buttonSpacing;
			
			this.buttons.push(new ToolbarButton(x, y, Toolbar.GFX_TOOLBAR_BUTTON_PROBE, this.buttonPressed, Toolbar.BUTTON_PROBE));
			x += ToolbarButton.WIDTH + this.buttonSpacing;
			
			this.buttons.push(new ToolbarButton(x, y, Toolbar.GFX_TOOLBAR_BUTTON_PIPETTE, this.buttonPressed, Toolbar.BUTTON_PIPETTE));
			x += ToolbarButton.WIDTH + this.buttonSpacing;
			
			this.buttons.push(new ToolbarButton(x, y, Toolbar.GFX_TOOLBAR_BUTTON_TWEEZERS, this.buttonPressed, Toolbar.BUTTON_TWEEZERS));
			x += ToolbarButton.WIDTH + this.buttonSpacing;
			
			this.buttons.push(new ToolbarButton(x, y, Toolbar.GFX_TOOLBAR_BUTTON_SCALPEL, this.buttonPressed, Toolbar.BUTTON_SCALPEL));
			x += ToolbarButton.WIDTH + this.buttonSpacing;
			
			for (i = 0; i < this.buttons.length; i++) this.add(this.buttons[i], true); 
			
			this.pauseButton = new FlxSprite(10, 2);
			this.pauseButton.createGraphic(80, 25, 0x00FFFF00);
			this.add(this.pauseButton, true);
		}
		
		private function buttonPressed(arg : Object) : void
		{
			PlayingState.instance.setActiveTool(arg as int);
		}
		
		public function setActiveButton(index : int) : void
		{
			var i : int;
			
			for (i = 0; i < this.buttons.length; i++) this.buttons[i].isOn = false;
			this.buttons[index].isOn = true;
		}
		
		public function disableButton(index : int) : void
		{
			this.buttons[index].isEnabled = false;
		}
		
		public function enableButton(index : int) : void
		{
			this.buttons[index].isEnabled = true;
		}
		
		public function toggleButtonEnabled(index : int) : void 
		{
			this.buttons[index].isEnabled = !this.buttons[index].isEnabled;
		}
		
		public function isButtonEnabled(index : int) : Boolean
		{
			if (index >= this.buttons.length) return false;
			return this.buttons[index].isEnabled;
		}
		
		public function get background() : FlxSprite
		{
			return this.backgroundSprite;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (
				FlxG.mouse.justPressed() &&
				this.pauseButton.overlapsPointScreenspace(FlxG.mouse.screenX, FlxG.mouse.screenY))
			{
				FlxG.pause = true;
			}
			
			if (Main.DEBUG)
			{
				this.updateDebug();
			}
		}
		
		private function updateDebug() : void
		{
			/*
			if (FlxG.keys.justPressed("FIVE")) this.toggleButtonEnabled(0);
			if (FlxG.keys.justPressed("SIX")) this.toggleButtonEnabled(1);
			if (FlxG.keys.justPressed("SEVEN")) this.toggleButtonEnabled(2);
			if (FlxG.keys.justPressed("EIGHT")) this.toggleButtonEnabled(3);
			if (FlxG.keys.justPressed("NINE")) this.toggleButtonEnabled(4);
			*/
		}
		
		public function getButton(index : int) : ToolbarButton
		{
			return this.buttons[index];
		}
		
		public function isOverPauseButton(x : int, y : int) : Boolean
		{
			return this.pauseButton.overlapsPointScreenspace(x, y);
		}
	}

}