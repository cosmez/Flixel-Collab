package org.flixel
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * Used for showing infinitely scrolling backgrounds.
	 * @author Chevy Ray
	 */
	public class FlxBackdrop extends FlxSprite
	{
		private var
			_data:BitmapData,
			_ppoint:Point,
			_scrollW:int,
			_scrollH:int,
			_repeatX:Boolean,
			_repeatY:Boolean;
		public var
			scrollX:Number,
			scrollY:Number,
			auto:Boolean;
			
		/**
		 * Creates an instance of the FlxBackdrop class, used to create infinitely scrolling backgrounds.
		 * @param	bitmap The image you want to use for the backdrop.
		 * @param	scrollX Scrollrate on the X axis.
		 * @param	scrollY Scrollrate on the Y axis.
		 * @param	repeatX If the backdrop should repeat on the X axis.
		 * @param	repeatY If the backdrop should repeat on the Y axis.
		 * @param	Whether to automatically scroll the background based on scrollX and scrollY.
		 */
		public function FlxBackdrop(bitmap:Class, scrollX:Number = 0, scrollY:Number = 0, repeatX:Boolean = true, repeatY:Boolean = true, auto:Boolean = false) 
		{
			// Move most of this stuff into loadGraphic?
			// In fact, look inside loadGraphic(). It does some extra stuff, like FlxG.addBitmap()
			// There should be animation support, too!
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
			
			this.scrollX = scrollX;
			this.scrollY = scrollY;
			
			this.auto = auto;
		}
		
		
		
		// This just makes it so that auto works. should be changed later
		override protected function updateMotion():void
		{
			if (auto)
			{
				velocity.x = scrollX;
				velocity.y = scrollY;
				solid = false;
				scrollFactor.x = scrollFactor.y = 0;
			}
			
			super.updateMotion();
			
			if (auto)
			{
				x = x % FlxG.width;
				y = y % FlxG.height;
			}
		}
		
		
		
		// Ideally this would be overriden to generate the huge bitmapdata for repeating.
		override public function loadGraphic(Graphic:Class,Animated:Boolean=false,Reverse:Boolean=false,Width:uint=0,Height:uint=0,Unique:Boolean=false):FlxSprite
		{
			return super.loadGraphic(Graphic, Animated, Reverse, Width, Height, Unique);
			
			// extra stuff here
		}
		
		
		
		// for repeating backgrounds:
		// draw the subrect of the large image that should be currently seen.
		// this subrect is as big as the size of this Backdrop.
		// clamp subrect UL position to be inside the UL quadrant
		
		
		
		
		override public function render():void
		{
			if (!_data) return;
			
			// find x position
			if (_repeatX)
			{
				_ppoint.x = (x + FlxG.scroll.x * scrollX) % _scrollW;
				if (_ppoint.x > 0) _ppoint.x -= _scrollW;
			}
			else _ppoint.x = (x + FlxG.scroll.x * scrollX);
			
			// find y position
			if (_repeatY)
			{
				_ppoint.y = (y + FlxG.scroll.y * scrollY) % _scrollH;
				if (_ppoint.y > 0) _ppoint.y -= _scrollH;
			}
			else _ppoint.y = (y + FlxG.scroll.y * scrollY);
			
			// draw to the screen.
			FlxG.buffer.copyPixels(_data, _data.rect, _ppoint, null,null,true);
		}
	}
}