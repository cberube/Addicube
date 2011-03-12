package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.states.PlayingState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class FoodChain extends FlxGroup
	{
		
		private var poofs : Array;
		
		private var direction : FlxPoint;
		
		private var previousPosition : FlxPoint;
		
		public function FoodChain() 
		{
			this.previousPosition = new FlxPoint();
		}
		
		public function spawn(x : int, y : int) : void
		{
			this.poofs = new Array();
			
			this.x = x;
			this.y = y;
			
			this.direction = new FlxPoint(
				PlayingState.instance.petriDish.center.x - this.x,
				PlayingState.instance.petriDish.center.y - this.y
			);
			
			this.direction = FlxPoint.normalize(this.direction);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		public function removePoof(p : FoodPoof) : void
		{
			var i : int;
			var index : int;
			
			index = -1;
			
			for (i = 0; i < this.poofs.length; i++)
			{
				if (this.poofs[i] == p)
				{
					index = i;
					break;
				}
			}
			
			if (index >= 0)
			{
				this.poofs.splice(index, 1);
			}
			
			p.ownerChain = null;
		}
		
		public function addPoof(color : int = -1) : void
		{
			var poof : FoodPoof;
			var i : int;
			var d : Number;
			var da : FlxPoint;
			var angle : Number;
			var p : FlxPoint;
			
			poof = PlayingState.instance.getFoodPoof();
			
			//FlxG.log("FCD: " + this.direction.x + ", " + this.direction.y);
			
			d = this.poofs.length * /*poof.width*/ 8 * 3;
			i = this.poofs.length;
			
			poof.spawn(
				this.x + d * this.direction.x,
				this.y + d * this.direction.y,
				color
			);
			
			angle = Math.atan2(this.direction.y, this.direction.x);
			angle += Math.PI / 2;
			
			da = new FlxPoint(Math.cos(angle), Math.sin(angle));
			
			poof.bindToChain(
				this,
				poof.center,
				da,
				d,
				i * 3
			);
			
			this.poofs.push(poof);
		}
		
		public override function reset(x : Number, y : Number) : void
		{
			var i : int;
			var d : FlxPoint;
			
			this.previousPosition.x = this.x;
			this.previousPosition.y = this.y;
			
			super.reset(x, y);
			
			d = new FlxPoint(
				x - this.previousPosition.x,
				y - this.previousPosition.y
			);
			
			for (i = 0; i < this.poofs.length; i++)
			{
				/*this.poofs[i].reset(
					this.poofs[i].x + d.x,
					this.poofs[i].y + d.y
				);*/
				this.poofs[i].adjustBasePosition(d.x, d.y);
			}
			
			//this.x = x;
			//this.y = y;
		}
		
		public function getHeadPoof() : FoodPoof
		{
			return this.poofs[0];
		}
		
		public function getTailPoof() : FoodPoof 
		{
			return this.poofs[this.poofs.length - 1];
		}
		
		public function splitAt(poof : FoodPoof) : void
		{
			var poofIndex : int;
			var i : int;
			var newChain : FoodChain;
			var poofsToRemove : Array = new Array();
			
			for (i = 0; i < this.poofs.length; i++)
			{
				if (this.poofs[i] == poof)
				{
					poofIndex = i;
					break;
				}
			}
			
			if (poofIndex == 0)
			{
				//	Special case -- cutting off the head poof
				this.removePoof(poof);
			}
			else if (poofIndex == this.poofs.length - 1)
			{
				//	Special case -- cutting off the tail poof
				this.removePoof(poof);
			}
			else
			{
				//	Cutting the chain anywhere else
				for (i = poofIndex; i < this.poofs.length; i++)
				{
					poofsToRemove.push(this.poofs[i]);
				}
				
				if (poofsToRemove.length > 1)
				{
					newChain = PlayingState.instance.getEmptyFoodChain();
					newChain.spawn(poof.x, poof.y);
				}
				else
				{
					newChain = null;
				}
				
				for (i = 0; i < poofsToRemove.length; i++)
				{
					poofsToRemove[i].kill();
					this.removePoof(poofsToRemove[i]);
					if (newChain != null) newChain.addPoof(poofsToRemove[i].colorId);
				}
				
				//	If we wound up with a chain of length one,
				//	destroy the chain and make the poof a free poof
				if (this.poofs.length == 1)
				{
					this.removePoof(this.poofs[0]);
					this.kill();
				}
			}
		}
		
		public function get poofCount() : int { return this.poofs.length; }
	}

}