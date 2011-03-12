package com.wasabi.shared.states 
{
	import flash.display.DisplayObject;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class WasabiGameState extends FlxState
	{
		
		private static const TRANSITION_TIME : Number = 0.3;
		
		protected var flashDisplayObjects : Array;
		
		protected var isTransitioning : Boolean;
		protected var transitionClock : Number;
		
		protected var nextState : FlxState;
		
		public function WasabiGameState() 
		{
		}
		
		override public function create():void 
		{
			super.create();
			
			this.flashDisplayObjects = new Array();
			
			this.isTransitioning = false;
			this.transitionClock = 0.0;
			
			this.nextState = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (this.isTransitioning)
			{
				this.transitionClock += FlxG.elapsed;
				if (this.transitionClock >= WasabiGameState.TRANSITION_TIME)
				{
					this.endTransition();
				}
			}
		}
		
		public function get transitioning() : Boolean
		{
			return this.isTransitioning;
		}
		
		public function switchState(newState : FlxState) : void
		{
			this.nextState = newState;
			this.beginTransition();
		}
		
		public function addDisplayObject(d : DisplayObject) : void
		{
			this.flashDisplayObjects.push(d);
			if (!this.stage.contains(d)) this.stage.addChild(d);
		}
		
		public function removeDisplayObject(d : DisplayObject) : void
		{
			if (this.stage.contains(d)) this.stage.removeChild(d);
			
			for (var i : int = 0; i < this.flashDisplayObjects.length; i++)
			{
				if (this.flashDisplayObjects[i] == d)
				{
					this.flashDisplayObjects.splice(i, 1);
				}
			}
		}
		
		protected function beginTransition() : void
		{
			this.isTransitioning = true;
			this.transitionClock = 0;
		}
		
		protected function endTransition() : void
		{
			this.isTransitioning = false;
			this.onTransitionComplete();
		}
		
		protected function onTransitionComplete() : void
		{
			if (this.nextState != null)
			{
				FlxG.state = this.nextState;
			}
		}
	}

}