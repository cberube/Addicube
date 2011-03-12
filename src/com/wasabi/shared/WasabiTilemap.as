package com.wasabi.shared 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class WasabiTilemap extends FlxTilemap
	{
		
		public var tileVisible : Array;
		
		public function WasabiTilemap() 
		{
			this.tileVisible = new Array();
		}
		
		override public function loadMap(MapData:String, TileGraphic:Class, TileWidth:uint = 0, TileHeight:uint = 0):FlxTilemap 
		{
			super.loadMap(MapData, TileGraphic, TileWidth, TileHeight);
			
			this.setGlobalVisibility(true);
			return this;
		}
		
		public function setGlobalVisibility(v : Boolean) : void
		{
			for (var y : int = 0; y < this.heightInTiles; y++)
			{
				for (var x : int = 0; x < this.widthInTiles; x++)
				{
					this.tileVisible[(y * this.widthInTiles) + x] = v;
				}
			}
		}
		
		/**
		 * Internal function that actually renders the tilemap.  Called by render().
		 */
		override protected function renderTilemap():void 
		{
			//Bounding box display options
			var tileBitmap:BitmapData;
			if(FlxG.showBounds)
				tileBitmap = _bbPixels;
			else
				tileBitmap = _pixels;

			getScreenXY(_point);
			_flashPoint.x = _point.x;
			_flashPoint.y = _point.y;
			var tx:int = Math.floor(-_flashPoint.x/_tileWidth);
			var ty:int = Math.floor(-_flashPoint.y/_tileHeight);
			if(tx < 0) tx = 0;
			if(tx > widthInTiles-_screenCols) tx = widthInTiles-_screenCols;
			if(ty < 0) ty = 0;
			if(ty > heightInTiles-_screenRows) ty = heightInTiles-_screenRows;
			var ri:int = ty*widthInTiles+tx;
			_flashPoint.x += tx*_tileWidth;
			_flashPoint.y += ty*_tileHeight;
			var opx:int = _flashPoint.x;
			var c:uint;
			var cri:uint;
			for(var r:uint = 0; r < _screenRows; r++)
			{
				cri = ri;
				for(c = 0; c < _screenCols; c++, cri++)
				{
					if (this.tileVisible[cri])
					{
						_flashRect = _rects[cri] as Rectangle;
						if(_flashRect != null)
							FlxG.buffer.copyPixels(tileBitmap,_flashRect,_flashPoint,null,null,true);
					}
					
					_flashPoint.x += _tileWidth;
				}
				ri += widthInTiles;
				_flashPoint.x = opx;
				_flashPoint.y += _tileHeight;
			}
		}
	}

}