package com.wasabi.addicube
{
	import com.wasabi.addicube.states.PlayingState;
	import com.wasabi.addicube.states.SplashState;
	import com.wasabi.addicube.states.TitleState;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class Main extends FlxGame 
	{
		
		public static const VERSION : String = "Post-IGF Beta - 02/12/2011 - R3";
		public static const SCREEN_WIDTH : int = 500;
		public static const SCREEN_HEIGHT : int = 400;
		
		public static const DEBUG : Boolean = true;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			super(
				Main.SCREEN_WIDTH, Main.SCREEN_HEIGHT,
				Main.DEBUG ? TitleState : SplashState,
				1
			);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}