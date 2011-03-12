package com.wasabi.addicube.states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class GameState extends FlxState
	{
		
		public function GameState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			
			FlxG.mouse.show();
		}
		
		protected function switchState(targetState : GameState) : void
		{
			FlxG.state = targetState;
		}
	}

}