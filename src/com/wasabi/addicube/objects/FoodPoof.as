package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.data.Disposition;
	import com.wasabi.addicube.Main;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class FoodPoof extends GameObject
	{
		
		[Embed(source = '../../../../../assets/puff.00.png')]
		private static const GFX_POOF_1 : Class;
		
		[Embed(source = '../../../../../assets/puff.01.png')]
		private static const GFX_POOF_2 : Class;
		
		[Embed(source = '../../../../../assets/puff.02.png')]
		private static const GFX_POOF_3 : Class;
		
		private static const COLOR_DATA_BRIGHT : int = 0;
		private static const COLOR_DATA_WILTED : int = 1;
		
		private static const DEFAULT_LIFETIME : Number = 5.0;
		
		//	Color data
		//	Color ID : [ Bright color, Wilted color ]
		private static const COLOR_DATA : Object =
		{
			//	RED
			1: [ 0xFF0000, 0x442200 ],
			
			//	GREEN
			2: [ 0x00CC00, 0x116600 ],
			
			//	BLUE
			3: [ 0x0000AA, 0x220044 ]
		};
		
		public var colorId : int;
		
		public var ownerCube : Cube;
		public var ownerChain : FoodChain;
		
		public var basePosition : FlxPoint;
		public var driftAxis : FlxPoint;
		
		private var driftClock : Number;
		private var driftScale : Number;
		
		private var delayClock : Number;
		private var growthClock : Number;
		private var growthTime : Number;
		
		public function FoodPoof() 
		{
			this.addAnimation("Grow", [ 0 ]);
			this.addAnimation("Exist", [ 0 ]);
			this.addAnimation("Decay", [ 0 ]);
			
			this.delayClock = 0;
			this.growthClock = 0;
			this.growthTime = 0.65;
		}
		
		override public function kill():void 
		{
			super.kill();
			
			if (this.ownerChain != null)
			{
				this.ownerChain.removePoof(this);
				this.ownerChain = null;
			}
		}
		
		public function bindToChain(c : FoodChain, bp : FlxPoint, da : FlxPoint, offset : Number, ds : Number) : void
		{
			this.ownerChain = c;
			this.basePosition = bp;
			this.driftAxis = da;
			this.driftClock = offset;
			this.driftScale = ds;
		}
		
		public function randomizeColor() : void
		{
			var which : Number = FlxU.random();
			var colorId : int;
			
			if (which <= 0.33) colorId = Disposition.RED;
			else if (which <= 0.66) colorId = Disposition.GREEN;
			else colorId = Disposition.BLUE;
			
			this.colorId = colorId;
			this.color = FoodPoof.COLOR_DATA[this.colorId][FoodPoof.COLOR_DATA_BRIGHT];
		}
		
		public function adjustBasePosition(dx : int, dy : int) : void
		{
			this.basePosition.x += dx;
			this.basePosition.y += dy;
		}
		
		public function spawn(x : int, y : int, colorId : int = -1, delay : Number = 0) : void
		{
			if (this.ownerCube != null)
			{
				this.ownerCube.relinquishSpecificFood(this);
				this.ownerCube = null;
				FlxG.log("Spawned a poof with an owner!!");
			}
			
			this.reset(x, y);
			this.ownerChain = null;
			
			if (colorId < 0)
			{
				this.randomizeColor();
			}
			else
			{
				this.colorId = colorId;
				this.color = FoodPoof.COLOR_DATA[this.colorId][FoodPoof.COLOR_DATA_BRIGHT];
			}
			
			var which : Number = FlxU.random();
			
			if (which <= 0.33) this.loadGraphic(FoodPoof.GFX_POOF_1);
			else if (which <= 0.66) this.loadGraphic(FoodPoof.GFX_POOF_2);
			else this.loadGraphic(FoodPoof.GFX_POOF_3);
			
			this.growthClock = 0;
			this.delayClock = delay;
			this.visible = false;
			this.scale.x = this.scale.y = 0;
			this.exists = true;
			
			if (this.delayClock == 0)
			{
				this.play("Grow");
				this.visible = true;
				this.growthClock = 0;
			}
			
			this.ownerCube = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			var o : Number;
			
			if (this.delayClock > 0)
			{
				this.delayClock -= FlxG.elapsed;
				if (this.delayClock <= 0)
				{
					this.play("Grow");
					this.visible = true;
				}
				else
				{
					return;
				}
			}
			
			if (this.growthClock < this.growthTime)
			{
				this.growthClock += FlxG.elapsed;
				this.scale.x = this.scale.y = (this.growthClock / this.growthTime);
				return;
			}
			
			if (this._curAnim.name == "Grow" && this.finished)
			{
				this.play("Exist");
			}
			
			if (this.ownerChain != null)
			{
				this.driftClock += FlxG.elapsed;
				
				o = Math.sin(this.driftClock) * this.driftAxis.x * this.driftScale;
				this.x = this.basePosition.x + o - this.width / 2;
				
				o = Math.sin(this.driftClock) * this.driftAxis.y * this.driftScale;
				this.y = this.basePosition.y + o - this.height / 2;
			}
			
		}
		
		public function get isReady() : Boolean
		{
			if (
				this.visible &&
				this.exists &&
				this.delayClock <= 0 &&
				this.growthClock >= this.growthTime
			)
			{
				return true;
			}
			return false;
		}
	}
	
}