package org.flixel
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * Used for showing infinitely scrolling backgrounds.
	 * @author Chevy Ray
	 */
	public class FlxBackdrop extends FlxObject
	{
		private var
			_data:BitmapData,
			_ppoint:Point,
			_scrollX:Number,
			_scrollY:Number,
			_scrollW:int,
			_scrollH:int,
			_repeatX:Boolean,
			_repeatY:Boolean;
		
			
		/**
		 * Creates an instance of the FlxBackdrop class, used to create infinitely scrolling backgrounds.
		 * @param	bitmap The image you want to use for the backdrop.
		 * @param	scrollX Scrollrate on the X axis.
		 * @param	scrollY Scrollrate on the Y axis.
		 * @param	repeatX If the backdrop should repeat on the X axis.
		 * @param	repeatY If the backdrop should repeat on the Y axis.
		 */
		public function FlxBackdrop(bitmap:Class, scrollX:Number = 0, scrollY:Number = 0, repeatX:Boolean = true, repeatY:Boolean = true) 
		{
			var data:BitmapData = (new bitmap).bitmapData,
				w:int = data.width,
				h:int = data.height;
			if (repeatX) w += FlxG.width;
			if (repeatY) h += FlxG.height;
			
			_data = new BitmapData(w, h);
			_ppoint = new Point();
			
			_scrollW = data.width;
			_scrollH = data.height;
			_repeatX = repeatX;
			_repeatY = repeatY;
			
			while (_ppoint.y < _data.height + data.height)
			{
				while (_ppoint.x < _data.width + data.width)
				{
					_data.copyPixels(data, data.rect, _ppoint);
					_ppoint.x += data.width;
				}
				_ppoint.x = 0;
				_ppoint.y += data.height;
			}
			
			_scrollX = scrollX;
			_scrollY = scrollY;
		}
		
		override public function render():void
		{
			if (!_data) return;
			
			// find x position
			if (_repeatX)
			{
				_ppoint.x = (x + FlxG.scroll.x * _scrollX) % _scrollW;
				if (_ppoint.x > 0) _ppoint.x -= _scrollW;
			}
			else _ppoint.x = (x + FlxG.scroll.x * _scrollX);
			
			// find y position
			if (_repeatY)
			{
				_ppoint.y = (y + FlxG.scroll.y * _scrollY) % _scrollH;
				if (_ppoint.y > 0) _ppoint.y -= _scrollH;
			}
			else _ppoint.y = (y + FlxG.scroll.y * _scrollY);
			
			// draw to the screen
			
			FlxG.buffer.copyPixels(_data, _data.rect, _ppoint, null,null,true);
		}
	}
}