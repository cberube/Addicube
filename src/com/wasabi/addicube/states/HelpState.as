package com.wasabi.addicube.states 
{
	import com.wasabi.addicube.states.GameState;
	import com.wasabi.addicube.ui.AddicubeButton;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class HelpState extends GameState
	{
		
		private var backButton : AddicubeButton;
		
		public function HelpState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			
			var padding : int = 10;
			
			this.backButton = new AddicubeButton("Back", this.onBack, AddicubeButton.GFX_BUTTON_OFF, AddicubeButton.GFX_BUTTON_ON);
			this.backButton.x = padding;
			this.backButton.y = FlxG.height - padding - this.backButton.height;
			this.add(this.backButton);
		}
		
		private function onBack() : void
		{
			this.switchState(new TitleState());
		}
		
	}

}