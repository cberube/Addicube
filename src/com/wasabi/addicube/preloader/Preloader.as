package com.wasabi.addicube.preloader 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class Preloader extends MovieClip
	{
		
		private static const MAIN_CLASS : String = "com.wasabi.addicube.Main";
		
		private static const BAR_WIDTH : int = 300;
		private static const BAR_HEIGHT : int = 20;
		private static const PADDING : int = 4;
		
		private var border : Sprite;
		private var bar : Sprite;
		
		private var time : Number;
		private var maxTime : Number = 5.0;
		
		private var debugMode : Boolean = false;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.time = 0;
			
			this.border = new Sprite();
			this.border.graphics.lineStyle(1, 0xFF0000);
			this.border.graphics.drawRect(
				0, 0,
				Preloader.BAR_WIDTH + Preloader.PADDING * 2,
				Preloader.BAR_HEIGHT + Preloader.PADDING * 2
			);
			this.border.x = 1000 / 2 - this.border.width / 2;
			this.border.y = 400 / 2 - this.border.height / 2;
			this.addChild(this.border);
			
			this.bar = new Sprite();
			this.bar.graphics.beginFill(0x000000);
			this.bar.graphics.drawRect(0, 0, Preloader.BAR_WIDTH, Preloader.BAR_HEIGHT);
			this.bar.graphics.endFill();
			this.bar.x = this.border.x + Preloader.PADDING;
			this.bar.y = this.border.y + Preloader.PADDING;
			this.addChild(this.bar);
		}
		
		private function onEnterFrame(event:Event):void
        {
			var percent : Number;
			
			if (this.debugMode)
			{
				this.time += (1.0 / 60.0);
				
				if (this.time >= this.maxTime)
				{
					this.startup();
				}
				else
				{
					percent = (this.time / this.maxTime);
					this.update(percent);
				}
			}
			else
			{
				if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
				{
					this.startup();
				}
				else
				{
					percent = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
					this.update(percent);
				}
			}
        }
		
		private function update(percent : Number) : void
		{
			var barWidth : int = percent * Preloader.BAR_WIDTH;
			
			this.bar.graphics.clear();
			this.bar.graphics.beginFill(0xFF0000);
			this.bar.graphics.drawRect(0, 0, barWidth, 20);
			this.bar.graphics.endFill();
		}
		
		private function startup() : void
		{
			this.update(1.0);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			nextFrame();
			
			var mainClass : Class;
			
			mainClass = getDefinitionByName(Preloader.MAIN_CLASS) as Class;
			
			if(mainClass)
			{
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}

}