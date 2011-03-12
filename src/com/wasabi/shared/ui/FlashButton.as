package com.wasabi.shared.ui 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class FlashButton extends Sprite
	{
		//	The function to call when the button is clicked
		private var callback : Function;
		
		//	User defined arguments to the callback function
		private var callbackArguments : Object;
		
		//	Collection of images for the various states of the button
		private var standardImage : DisplayObject;
		private var hoverImage : DisplayObject;
		private var pressedImage : DisplayObject;
		private var disabledImage : DisplayObject;
		
		//	Internal state tracking
		private var isEnabled : Boolean;
		private var isHovered : Boolean;
		
		public function FlashButton(cb : Function = null, cbArgs : Object = null) 
		{
			this.buttonMode = this.useHandCursor = true;
			
			this.isEnabled = true;
			this.isHovered = false;
			
			this.callback = cb;
			this.callbackArguments = cbArgs;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.addEventListener(MouseEvent.CLICK, this.onClick);
		}
		
		/*
		 * Adds state images to this FlashButton
		 */
		public function loadImages(standard : DisplayObject, hover : DisplayObject = null, pressed : DisplayObject = null, disabled : DisplayObject = null) : void
		{
			this.standardImage = standard;
			this.hoverImage = (hover == null) ? this.standardImage : hover;
			this.pressedImage = (pressed == null) ? this.standardImage : pressed;
			this.disabledImage = (disabled == null) ? this.standardImage : disabled;
			
			this.addChild(this.standardImage);
			if (this.hoverImage != this.standardImage) this.addChild(this.hoverImage);
			if (this.pressedImage != this.standardImage) this.addChild(this.pressedImage);
			if (this.disabledImage != this.standardImage) this.addChild(this.standardImage);
			
			this.displayStateImage();
		}
		
		/*
		 * Returns true if the button is currently enabled
		 */
		public function get enabled() : Boolean
		{
			return this.isEnabled;
		}
		
		/*
		 * Toggle the enabled / disabled state of the button and update the state image (if necessary)
		 */
		public function set enabled(e : Boolean) : void
		{
			this.isEnabled = e;
			this.displayStateImage();
		}
		
		/*
		 * Removes all the state images from this sprite
		 */
		private function removeImageChildren() : void
		{
			if (this.contains(this.standardImage)) this.removeChild(this.standardImage);
			if (this.contains(this.hoverImage)) this.removeChild(this.hoverImage);
			if (this.contains(this.disabledImage)) this.removeChild(this.disabledImage);
			if (this.contains(this.pressedImage)) this.removeChild(this.pressedImage);
		}
		
		/*
		 * Displays a single state image based on the current state of the button
		 */
		private function displayStateImage() : void
		{
			this.hideStateImages();
			
			if (this.isEnabled)
			{
				if (this.isHovered)
				{
					this.hoverImage.visible = true;
				}
				else
				{
					this.standardImage.visible = true;
				}
			}
			else
			{
				this.disabledImage.visible = true;
			}
		}
		
		/*
		 * Hides all of the state images for this button
		 */
		private function hideStateImages() : void
		{
			this.standardImage.visible = this.hoverImage.visible = false;
			this.disabledImage.visible = this.pressedImage.visible = false;
		}
		
		private function onMouseOver(e : Event) : void
		{
			FlxG.mouse.hide();
			Mouse.show();
			
			this.isHovered = true;
			this.displayStateImage();
		}
		
		private function onMouseOut(e : Event) : void
		{
			FlxG.mouse.show();
			Mouse.hide();
			
			this.isHovered = false;
			this.displayStateImage();
		}
		
		private function onClick(e : Event) : void
		{
			if (this.isEnabled && this.callback != null)
			{
				if (this.callbackArguments != null) this.callback(this.callbackArguments);
				else this.callback();
			}
		}
		
	}

}