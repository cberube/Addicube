package com.wasabi.addicube.states 
{
	import com.wasabi.addicube.utility.FadeSprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class SplashState extends GameState
	{
		
		private var background : FlxSprite;
		
		[Embed(source = '../../../../../assets/logos/screen01.png')]
		private static const GFX_ZAKELRO : Class;
		
		[Embed(source = '../../../../../assets/logos/screen02.png')]
		private static const GFX_AND : Class;
		
		[Embed(source = '../../../../../assets/logos/screen03.png')]
		private static const GFX_WASABI : Class;
		
		[Embed(source = '../../../../../assets/logos/screen04a.png')]
		private static const GFX_PRESENT : Class;
		
		[Embed(source = '../../../../../assets/logos/screen04b.png')]
		private static const GFX_ADDICUBE : Class;
		
		[Embed(source = '../../../../../assets/logos/thanks1.png')]
		private static const GFX_THANKS_1 : Class;
		
		[Embed(source = '../../../../../assets/logos/thanks2.png')]
		private static const GFX_THANKS_2 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo1.png')]
		private static const GFX_LOGO_1 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo2.png')]
		private static const GFX_LOGO_2 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo3.png')]
		private static const GFX_LOGO_3 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo4.png')]
		private static const GFX_LOGO_4 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo5.png')]
		private static const GFX_LOGO_5 : Class;
		
		[Embed(source = '../../../../../assets/logos/logo6.png')]
		private static const GFX_LOGO_6 : Class;
		
		private var t : Number;
		private var clickSprite : Sprite;
		
		private var graphicsData : Array =
		[
			[ GFX_ZAKELRO, 	0.25, 0.0, 0.5, 1.0, 1.5, "http://www.zakelro.com" ],
			[ GFX_AND, 		1.75, 0.0, 0.5, 1.0, 1.5, null ],
			[ GFX_WASABI, 	3.25, 0.0, 0.5, 1.0, 1.5, "http://www.thewasabiproject.com" ],
			[ GFX_PRESENT, 	4.75, 0.0, 0.5, 2.0, 2.5, null ],
			[ GFX_ADDICUBE,	5.75, 0.0, 0.5, 1.0, 1.5, null ],
			[ GFX_THANKS_1,	7.25, 0.0, 0.5, 10.0, 10.5, null ],
			[ GFX_LOGO_1,	7.75, 0.0, 0.5, 1.5, 2.0, "http://www.diygamer.com" ],
			[ GFX_LOGO_2,	9.75, 0.0, 0.5, 1.5, 2.0, "http://www.5thwallgaming.com" ],
			[ GFX_LOGO_3,	11.75, 0.0, 0.5, 1.5, 2.0, "http://www.gbgames.com" ],
			[ GFX_LOGO_4,	13.75, 0.0, 0.5, 1.5, 2.0, "http://www.guardiangamesportland.com" ],
			[ GFX_LOGO_5,	15.75, 0.0, 0.5, 1.5, 2.0, "http://www.larming.com" ],
			[ GFX_THANKS_2, 17.75, 0.0, 0.5, 1.5, 2.0, null ],
			[ GFX_LOGO_6,	17.75, 0.0, 0.5, 1.5, 2.0, null ],
		];
		
		public function SplashState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			
			t = 0;
			
			this.background = new FlxSprite(0, 0);
			this.background.createGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
			this.add(background);
			
			var i : int;
			var sprite : FadeSprite;
			var base : Number;
			
			for (i = 0; i < this.graphicsData.length; i++)
			{
				sprite = new FadeSprite(0, 0, this.graphicsData[i][0]);
				base = this.graphicsData[i][1];
				sprite.start(
					base + this.graphicsData[i][2],
					base + this.graphicsData[i][3],
					base + this.graphicsData[i][4],
					base + this.graphicsData[i][5]
				);
				sprite.url = this.graphicsData[i][6];
				this.add(sprite);
			}
			
			this.clickSprite = new Sprite();
			this.clickSprite.graphics.beginFill(0xFF0000, 0.0);
			this.clickSprite.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
			this.clickSprite.graphics.endFill();
			this.clickSprite.mouseEnabled = this.clickSprite.buttonMode = true;
			this.clickSprite.addEventListener(MouseEvent.CLICK, this.onLogoClick);
			
			FlxG.stage.addChild(this.clickSprite);
		}
		
		override public function update():void 
		{
			super.update();
			
			t += FlxG.elapsed;
			
			if (t >= 19.75 && !FlxG.fade.exists)
			{
				FlxG.fade.start(0xFF000000, 1, this.fadeComplete);
			}
		}
		
		private function fadeComplete() : void
		{
			FlxG.state = new TitleState();
		}
		
		private function onLogoClick(e : Event) : void
		{
			var i : int;
			var s : FadeSprite;
			
			for (i = 0; i < this.defaultGroup.members.length; i++)
			{
				s = this.defaultGroup.members[i] as FadeSprite;
				if (s != null && s.hasBeenClicked) continue;
				
				if (s != null && s.exists && s.alpha > 0 && s.url != null)
				{
					navigateToURL(new URLRequest(s.url))
					s.hasBeenClicked = true;
				}
			}
		}
	}

}