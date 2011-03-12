package com.wasabi.addicube.states 
{
	import com.wasabi.addicube.ui.AddicubeButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class TitleState extends GameState
	{
		
		private var titleText : FlxText;
		private var infoText : FlxText;
		
		private var playButton : AddicubeButton;
		private var creditsButton : AddicubeButton;
		private var helpButton : AddicubeButton;
		
		public function TitleState() 
		{
		}
		
		override public function create():void 
		{
			super.create();
			
			this.titleText = new FlxText(20, 20, FlxG.width - 40, "Addicube");
			this.titleText.size = 48;
			this.add(this.titleText);
			
			this.infoText = new FlxText(20, 20 + this.titleText.height + 10, FlxG.width - 20);
			this.infoText.text =
				"Press R to generate a new set of Cubes\n" +
				"Press W to increase the number of Cubes on screen\n" +
				"Press Q to decrease the number of Cubes on screen\n" +
				"Press B to toggle the diplay of Cube collision objects\n" +
				"Use the ARROW KEYs to scroll\n" +
				"Press ~ for the flixel console (with frame rate details)\n" +
				"Press 1, 2, 3, 4, 5 to select various tools (or click on the tool icons)\n" +
				"\tPress 6, 7, 8, 9 to disable tools (the pan tool cannot be disabled)\n" +
				"CLICK a cube to randomly change it's color\n" +
				"When using the probe, HOLD the left mouse button to generate a radius of influence;\n" +
				"\tonly cubes inside the radius will respond to the probe; these cubes will be highlighted in red.\n" +
				"\nClick the play button to start"
			;
			
			this.add(this.infoText);
			
			//	Buttons
			var padding : int = 10;
			var x : int;
			
			this.playButton = new AddicubeButton("Play", this.onPlay, AddicubeButton.GFX_BUTTON_OFF, AddicubeButton.GFX_BUTTON_ON);
			this.playButton.x = FlxG.width - padding - this.playButton.width;
			this.playButton.y = FlxG.height - padding - this.playButton.height;
			this.add(this.playButton);
			
			this.creditsButton = new AddicubeButton("Credits", this.onCredits, AddicubeButton.GFX_BUTTON_OFF, AddicubeButton.GFX_BUTTON_ON);
			this.creditsButton.x = padding;
			this.creditsButton.y = FlxG.height - padding - this.creditsButton.height;
			this.add(this.creditsButton);
			
			this.helpButton = new AddicubeButton("Help", this.onHelp, AddicubeButton.GFX_BUTTON_OFF, AddicubeButton.GFX_BUTTON_ON);
			this.helpButton.x = padding;
			this.helpButton.y = this.creditsButton.y - padding - this.helpButton.height;
			this.add(this.helpButton);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		private function onPlay() : void
		{
			this.switchState(new PlayingState());
		}
		
		private function onCredits() : void
		{
			this.switchState(new CreditsState());
		}
		
		private function onHelp() : void
		{
			this.switchState(new HelpState());
		}
	}

}