package com.wasabi.shared.ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Frame extends FlxGroup
	{
		
		private static const TOP_LEFT : int = 0;
		private static const TOP : int = 1;
		private static const TOP_RIGHT : int = 2;
		
		private static const LEFT : int = 3;
		private static const CENTER : int = 4;
		private static const RIGHT : int = 5;
		
		private static const BOTTOM_LEFT : int = 6;
		private static const BOTTOM : int = 7;
		private static const BOTTOM_RIGHT : int = 8;
		
		private static const MAX_SPRITE_INDEX : int = 8;
		private static const SPRITE_COUNT : int = 9;
		
		private var sprites : Array;
		
		private var graphicClass : Class;
		private var graphicData : BitmapData;
		protected var framePartSize : int;
		
		public function Frame(frameGraphic : Class, partSize : int = 0) 
		{
			var i : int
			var sprite : FlxSprite;
			
			this.sprites = new Array();
			
			this.graphicClass = frameGraphic;
			this.graphicData = FlxG.addBitmap(this.graphicClass);
			
			if (partSize <= 0)
			{
				partSize = Math.floor(this.graphicData.width / 3);
			}
			
			this.framePartSize = partSize;
			
			for (i = 0; i < Frame.SPRITE_COUNT; i++)
			{
				sprite = new FlxSprite();
				sprite.loadGraphic(this.graphicClass, true, false, this.framePartSize, this.framePartSize);
				sprite.antialiasing = false;
				sprite.solid = false;
				
				sprite.addAnimation("Exist", [ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]);
				sprite.play("Exist");
				sprite.frame = i;
				sprite.origin = new FlxPoint();
				
				this.sprites.push(sprite);
				this.add(sprite);
			}
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			var innerWidth : Number;
			var innerHeight : Number;
			
			super.reset(X, Y);
			
			innerWidth = this.width - this.framePartSize * 2.0;
			innerHeight = this.height - this.framePartSize * 2.0;
			
			this.sprites[Frame.TOP_LEFT].reset(this.x + 0, this.y + 0);
			this.sprites[Frame.TOP_RIGHT].reset(this.x + this.width - this.framePartSize, this.y + 0);
			this.sprites[Frame.TOP].reset(this.x + this.framePartSize, this.y + 0);
			this.sprites[Frame.TOP].scale = new FlxPoint(innerWidth / this.framePartSize, 1.0);
			
			this.sprites[Frame.BOTTOM_LEFT].reset(this.x + 0, this.y + this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM_RIGHT].reset(this.x + this.width - this.framePartSize, this.y + this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM].reset(this.x + this.framePartSize, this.y + this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM].scale = new FlxPoint(innerWidth / this.framePartSize, 1.0);
			
			this.sprites[Frame.LEFT].reset(this.x + 0, this.y + this.framePartSize);
			this.sprites[Frame.LEFT].scale = new FlxPoint(1.0, innerHeight / this.framePartSize);
			
			this.sprites[Frame.RIGHT].reset(this.x + this.width - this.framePartSize, this.y + this.framePartSize);
			this.sprites[Frame.RIGHT].scale = new FlxPoint(1.0, innerHeight / this.framePartSize);
			
			this.sprites[Frame.CENTER].reset(this.x + this.framePartSize, this.y + this.framePartSize);
			this.sprites[Frame.CENTER].scale = new FlxPoint(innerWidth / this.framePartSize, innerHeight / this.framePartSize);
		}
		
		public function setSize(w : int, h : int) : void
		{
			var innerWidth : Number;
			var innerHeight : Number;
			
			innerWidth = w - this.framePartSize * 2.0;
			innerHeight = h - this.framePartSize * 2.0;
			
			this.width = w;
			this.height = h;
			
			var i : int;
			
			for (i = 0; i < this.sprites.length; i++)
			{
				this.sprites[i].scrollFactor.x = this.scrollFactor.x;
				this.sprites[i].scrollFactor.y = this.scrollFactor.y;
			}
			
			this.sprites[Frame.TOP_LEFT].reset(0, 0);
			this.sprites[Frame.TOP_RIGHT].reset(this.width - this.framePartSize, 0);
			this.sprites[Frame.TOP].reset(this.framePartSize, 0);
			this.sprites[Frame.TOP].scale = new FlxPoint(innerWidth / this.framePartSize, 1.0);
			
			this.sprites[Frame.BOTTOM_LEFT].reset(0, this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM_RIGHT].reset(this.width - this.framePartSize, this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM].reset(this.framePartSize, this.height - this.framePartSize);
			this.sprites[Frame.BOTTOM].scale = new FlxPoint(innerWidth / this.framePartSize, 1.0);
			
			this.sprites[Frame.LEFT].reset(0, this.framePartSize);
			this.sprites[Frame.LEFT].scale = new FlxPoint(1.0, innerHeight / this.framePartSize);
			
			this.sprites[Frame.RIGHT].reset(this.width - this.framePartSize, this.framePartSize);
			this.sprites[Frame.RIGHT].scale = new FlxPoint(1.0, innerHeight / this.framePartSize);
			
			this.sprites[Frame.CENTER].reset(this.framePartSize, this.framePartSize);
			this.sprites[Frame.CENTER].scale = new FlxPoint(innerWidth / this.framePartSize, innerHeight / this.framePartSize);
		}
		
		public function setScrollFactor(sf : FlxPoint) : void
		{
			var i : int;
			
			for (i = 0; i < this.sprites.length; i++)
			{
				this.sprites[i].scrollFactor.x = sf.x;
				this.sprites[i].scrollFactor.y = sf.y;
			}
		}
	}

}