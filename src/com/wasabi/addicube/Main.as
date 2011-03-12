package com.wasabi.addicube
{
	import com.wasabi.addicube.states.TitleState;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Main extends FlxGame
	{
		
		public static const DEBUG_COLLISION : Boolean = true;
		
		public static const SCREEN_WIDTH : int = 500;
		public static const SCREEN_HEIGHT : int = 400;
		public static const SCREEN_ZOOM : Number = 1.0;
		
		public function Main():void 
		{
			super(Main.SCREEN_WIDTH, Main.SCREEN_HEIGHT, TitleState, Main.SCREEN_ZOOM);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}