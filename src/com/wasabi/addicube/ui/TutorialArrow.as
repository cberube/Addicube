package com.wasabi.addicube.ui 
{
	import com.wasabi.addicube.objects.Cube;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class TutorialArrow extends FlxSprite
	{
		
		[Embed(source = '../../../../../assets/ui/arrowDown.png')]
		private static const GFX_ARROW_DOWN : Class;
		
		[Embed(source = '../../../../../assets/ui/arrowUp.png')]
		private static const GFX_ARROW_UP : Class;
		
		private var attachedObject : FlxObject;
		
		private var bounceClock : Number;
		private var bounceAdjustment : Number;
		
		private var baseY : Number;
		
		public function TutorialArrow() 
		{
			super(0, 0);
			
			this.bounceClock = 0;
			this.bounceAdjustment = 0;
			
			this.setDirection(FlxSprite.UP);
		}
		
		public function setDirection(facing : int) : void
		{
			this.facing = facing;
			
			if (this.facing == FlxSprite.UP)
			{
				this.loadGraphic(TutorialArrow.GFX_ARROW_UP);
			}
			else
			{
				this.loadGraphic(TutorialArrow.GFX_ARROW_DOWN);
			}
		}
		
		public function attachToObject(o : FlxObject) : void
		{
			this.attachedObject = o;
			
			if (this.attachedObject != null)
			{
				this.scrollFactor.x = this.attachedObject.scrollFactor.x;
				this.scrollFactor.y = this.attachedObject.scrollFactor.y;
			}
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			
			this.baseY = Y;
		}
		
		override public function update():void 
		{
			super.update();
			
			this.bounceClock += FlxG.elapsed * 4;
			this.bounceAdjustment = Math.abs(Math.sin(this.bounceClock) * 15);
			
			if (this.attachedObject)
			{
				var cube : Cube;
				
				if (this.attachedObject is Cube)
				{
					this.facing = FlxSprite.DOWN;
					cube = this.attachedObject as Cube;
					
					this.reset(
						cube.center.x - this.width / 2,
						cube.center.y - this.height
					);
				}
				else
				{
					this.reset(
						this.attachedObject.x + this.attachedObject.width / 2 - this.width / 2,
						this.facing == FlxSprite.DOWN ? this.attachedObject.top - this.height : this.attachedObject.bottom
					);
				}
			}
			
			if (this.facing == FlxSprite.UP)
			{
				this.y = this.baseY + this.bounceAdjustment
			}
			else
			{
				this.y = this.baseY - this.bounceAdjustment
			}
		}
	}

}