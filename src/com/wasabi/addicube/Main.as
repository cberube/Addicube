package com.wasabi.addicube
{
	import com.wasabi.addicube.states.PlayingState;
	import com.wasabi.addicube.states.SplashState;
	import com.wasabi.addicube.states.TitleState;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class Main extends FlxGame 
	{
		
		public static const VERSION : String = "Post-IGF Beta - 04/01/2011 - R1";
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
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
		}
		
		private function mouseDown(e:MouseEvent = null):void
		{
			if (FlxG.pause)
			{
				if (PlayingState.instance.toolbar.isOverPauseButton(e.localX, e.localY))
				{
					FlxG.pause = false;
					e.stopImmediatePropagation();
				}
			}
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}