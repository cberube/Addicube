package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.objects.GameObject;
	import com.wasabi.addicube.states.PlayingState;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class FoodPoof extends GameObject
	{
		
		[Embed(source = '../../../../../assets/food.png')]
		public static const GFX_FOOD : Class;
		
		public static const COLOR_RED : uint = 0xFFFF0000;
		public static const COLOR_GREEN : uint = 0xFF00CC00;
		public static const COLOR_BLUE : uint = 0xFF0066EE;
		
		private static const POOF_GROWTH_RATE : Number = 0.75;
		
		private var poofScale : Number;
		
		private var growthDelay : Number;
		private var growthCount : int;
		
		private var lifetime : Number;
		private var age : Number;
		
		private var originalColor : uint;
		private var originalRGBA : Array;
		
		private var currentRGBA : Array;
		private var wiltedRGBA : Array;
		
		private var currentOwner : Cube;
		
		public function FoodPoof(x : int = 0, y : int = 0) 
		{
			super(x, y, FoodPoof.GFX_FOOD);
			
			this.originalRGBA = new Array();
			this.currentRGBA = new Array();
			this.wiltedRGBA = new Array();
			
			this.color = FoodPoof.COLOR_GREEN;
			FlxU.getRGBA(0xFF603913, this.wiltedRGBA);
			
			this.currentOwner = null;
		}
		
		public function spawn(x : int, y : int, canSpawnChildren : Boolean = true) : void
		{
			this.active = true;
			this.exists = true;
			this.visible = true;
			this.dead = false;
			
			this.poofScale = 0;
			this.scale.x = this.scale.y = 0;
			
			this.angle = FlxU.random() * 360;
			//this.angularVelocity = FlxU.random() * 90;
			//if (FlxU.random() < 0.5) this.angularVelocity *= -1;
			
			this.antialiasing = true;
			
			this.growthCount = canSpawnChildren ? FlxU.random() * 3 + 3 : 0;
			this.resetGrowthDelay();
			
			this.lifetime = FlxU.random() * 12 + 8;
			this.age = 0;
			
			this.reset(x, y);
		}
		
		public function get depth() : Number
		{
			return this.y;
		}
		
		public function setColor(c : uint) : void
		{
			this.color = this.originalColor = c;
			FlxU.getRGBA(this.originalColor, this.originalRGBA);
		}
		
		public function getColor() : uint
		{
			return this.originalColor;
		}
		
		private function resetGrowthDelay() : void
		{
			this.growthDelay = FlxU.random() * 3 + 2;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (this.poofScale < 1.0)
			{
				this.poofScale += FoodPoof.POOF_GROWTH_RATE * FlxG.elapsed;
				
				if (this.poofScale > 1.0) this.poofScale = 1.0;
				
				this.scale.x = this.scale.y = this.poofScale;
			}
			else
			{
				if (this.growthCount > 0)
				{
					var dx : int;
					var dy : int;
					
					this.growthDelay -= FlxG.elapsed;
					
					if (this.growthDelay <= 0)
					{
						this.growthCount--;
						this.resetGrowthDelay();
						
						dx = FlxU.random() * this.width / 2 + this.width / 2;
						dy = FlxU.random() * this.height / 2 + this.height / 2;
						
						if (FlxU.random() < 0.5) dx *= -1;
						if (FlxU.random() < 0.5) dy *= -1;
						
						PlayingState.instance.spawnFoodPoof(this.x + dx, this.y + dy, this.originalColor, false);
					}
				}
				
				this.age += FlxG.elapsed;
				if (this.age >= this.lifetime)
				{
					this.kill();
				}
				else
				{
					var percentage : Number = this.age / this.lifetime;
					
					this.currentRGBA[0] = FlxU.lerp(this.originalRGBA[0], this.wiltedRGBA[0], percentage);
					this.currentRGBA[1] = FlxU.lerp(this.originalRGBA[1], this.wiltedRGBA[1], percentage);
					this.currentRGBA[2] = FlxU.lerp(this.originalRGBA[2], this.wiltedRGBA[2], percentage);
					
					this.color = FlxU.getColor(this.currentRGBA[0], this.currentRGBA[1], this.currentRGBA[2]);
				}
			}
		}
		
		public function set owner(c : Cube) : void
		{
			this.currentOwner = owner;
		}
		
		public function get owner() : Cube
		{
			return this.currentOwner;
		}
		
	}

}