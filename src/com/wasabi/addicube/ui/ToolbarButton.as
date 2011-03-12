package com.wasabi.addicube.ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class ToolbarButton extends FlxSprite
	{
		
		public static const WIDTH : int = 48;
		public static const HEIGHT : int = 48;
		
		private var enabled : Boolean;
		private var hover : Boolean;
		private var on : Boolean;
		
		private var callback : Function;
		private var callbackArg : Object;
		
		public function ToolbarButton(x : int, y : int, gfx : Class, cb : Function = null, cbArg : Object = null) 
		{
			super(x, y);
			
			this.loadGraphic(gfx, true);
			this.addAnimation("Disabled", [ 0 ]);
			this.addAnimation("Off", [ 1 ]);
			this.addAnimation("Off-Hover", [ 2 ]);
			this.addAnimation("On", [ 3 ]);
			this.addAnimation("On-Hover", [ 4 ]);
			
			this.enabled = true;
			this.hover = false;
			this.on = false;
			
			this.callback = cb;
			this.callbackArg = cbArg;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (this.enabled)
			{
				if (this.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y))
				{
					this.isHovered = true;
					
					if (FlxG.mouse.justPressed() && this.callback != null)
					{
						this.callback(this.callbackArg);
					}
				}
				else if (this.hover)
				{
					this.isHovered = false;
				}
			}
		}
		
		private function updateImage() : void
		{
			if (this.enabled == false)
			{
				this.play("Disabled");
			}
			else
			{
				if (this.hover)
				{
					this.play(this.on ? "On-Hover" : "Off-Hover");
				}
				else
				{
					this.play(this.on ? "On" : "Off");
				}
			}
		}
		
		public function get isEnabled() : Boolean
		{
			return this.enabled;
		}
		
		public function set isEnabled(e : Boolean) : void
		{
			this.enabled = e;
			this.updateImage();
		}
		
		public function set isHovered(h : Boolean) : void
		{
			this.hover = h;
			this.updateImage();
		}
		
		public function set isOn(o : Boolean) : void
		{
			this.on = o;
			this.updateImage();
		}
		
	}

}