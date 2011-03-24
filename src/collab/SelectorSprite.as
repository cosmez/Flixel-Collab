package collab
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class SelectorSprite extends FlxObject
	{
		public var innerSegmentsCount:uint = 8;
		public var innerSegmentLength:uint = 24;
		public var innerSpeed:Number = -40;
		public var innerColor:uint;
		
		public var outerSegmentsCount:uint = 4;
		public var outerSegmentLength:uint = 32;
		public var outerSpeed:Number = 120;
		public var outerColor:uint;
		
		public var flashingColor:uint;
		public var shouldFlash:Boolean = false;
		public var thickness:uint;
		
		private var _flash:Boolean = false;
		private var _flashTimer:Number = 0;
		private var _innerTravelDist:Number = 0;
		private var _outerTravelDist:Number = 0;
		private var reversed:Boolean = false;
		
		
		
		public function SelectorSprite(X:int = 0, Y:int = 0, Width:int = 10, Height:int = 10)
		{
			super(x, y, Width, Height);
			//thickness = Thickness;
			innerColor = FlixelCollab.ARNE_PALETTE_ORANGE;
			flashingColor = FlixelCollab.ARNE_PALETTE_PALE_YELLOW;
			outerColor = innerColor;
		}
		
		
		
		// Yeah have fun figuring this out
		override public function render():void
		{
			if (shouldFlash)
			{
				_flashTimer -= FlxG.elapsed;
				if (_flashTimer < 0)
				{
					_flashTimer = 0.025;
					_flash = !_flash;
				}
			}
			
			// This is a hack to limit segment lengths since they can only wrap around 2 corners currently.
			if (innerSegmentLength > width || innerSegmentLength > height) innerSegmentLength = Math.min(width, height);
			if (outerSegmentLength > width || outerSegmentLength > height) outerSegmentLength = Math.min(width, height);
			
			var innerPerimeter:uint = 2 * (width + height + 2*((2*2) - 1));
			var outerPerimeter:uint = 2 * (width + height + 2*((2*3) - 1));
			
			_innerTravelDist = _innerTravelDist + (innerSpeed * FlxG.elapsed);
			if (_innerTravelDist < 0) _innerTravelDist += innerPerimeter;
			if (_innerTravelDist >= innerPerimeter) _innerTravelDist -= innerPerimeter;
			
			_outerTravelDist = _outerTravelDist + (outerSpeed * FlxG.elapsed);
			if (_outerTravelDist < 0) _outerTravelDist += outerPerimeter;
			if (_outerTravelDist >= outerPerimeter) _outerTravelDist -= outerPerimeter;
			
			// Yellow flashing outline.
			if (!shouldFlash || _flash)
			{
				var dfe:uint = 1;
				thickness = 4;
				FlxG.buffer.fillRect(new Rectangle(FlxG.scroll.x + x - dfe - (thickness-1), FlxG.scroll.y + y - dfe - (thickness-1), width + 2*dfe + 2*(thickness-1), thickness), flashingColor); // Top bar
				FlxG.buffer.fillRect(new Rectangle(FlxG.scroll.x + x + width + (dfe-1), FlxG.scroll.y + y - dfe - (thickness-1), thickness, height + 2*dfe + 2*(thickness-1)), flashingColor); // Right bar
				FlxG.buffer.fillRect(new Rectangle(FlxG.scroll.x + x - dfe - (thickness-1), FlxG.scroll.y + y - dfe - (thickness-1), thickness, height + 2*dfe + 2*(thickness-1)), flashingColor); // Left bar
				FlxG.buffer.fillRect(new Rectangle(FlxG.scroll.x + x - dfe - (thickness-1), FlxG.scroll.y + y + height + (dfe-1), width + 2*dfe + 2*(thickness-1), thickness), flashingColor); // Bottom bar
			}
			
			var curTravelDist:int;
			
			// Inner moving lines.
			for (var i:int = 0; i < innerSegmentsCount; i++)
			{
				curTravelDist = _innerTravelDist + (innerPerimeter * (i / innerSegmentsCount));
				if (curTravelDist < 0) curTravelDist += innerPerimeter;
				if (curTravelDist >= innerPerimeter) curTravelDist -= innerPerimeter;
				
				drawSpinner(curTravelDist, true);
			}
			
			// Outer moving lines.
			for (i = 0; i < outerSegmentsCount; i++)
			{
				curTravelDist = _outerTravelDist + (outerPerimeter * (i / outerSegmentsCount));
				if (curTravelDist < 0) curTravelDist += outerPerimeter;
				if (curTravelDist >= outerPerimeter) curTravelDist -= outerPerimeter;
				
				drawSpinner(curTravelDist, false);
			}
		}
		
		
		
		private function drawSpinner(TravelDist:uint, Inner:Boolean):void
		{
			var td:uint = TravelDist;
			var dfe:uint = (Inner) ? (2) : (3); // Distance From Edge (of selected box)
			var segLength:uint = (Inner) ? (innerSegmentLength) : (outerSegmentLength);
			var segColor:uint = (Inner) ? (innerColor) : (outerColor);
			var lineA:Rectangle = new Rectangle(FlxG.scroll.x + x, FlxG.scroll.y + y);
			var lineB:Rectangle = null;
			
			if (td < width + (2*dfe))
			{
				lineA.x += -dfe;
				lineA.y += -dfe;
				lineA.width = Math.min(segLength, td);
				lineA.height = 1;
				
				if (lineA.width < segLength) lineB = new Rectangle(lineA.x, lineA.y + 1, 1, segLength - lineA.width);
				else lineA.x += td - segLength;
				
				// I'm doing the drawing here so that the extra tail pixels wil be done correctly.
				FlxG.buffer.fillRect(lineA, segColor);
				if (lineB != null) FlxG.buffer.fillRect(lineB, segColor);
				
				// Technically, I could move the drawing stuff to the ver bottom for the solid line and do the tail stuff in here.
				// And shorten the width/height accordlingly, of course.
			}
			else if (td < (width + (2*dfe) - 1) + (height + (2*dfe)))
			{
				td -= width + (2*dfe) - 1;
				
				lineA.x += (width - 1) + dfe;
				lineA.y += -dfe;
				lineA.width = 1;
				lineA.height = Math.min(segLength, td);
				
				if (lineA.height < segLength) lineB = new Rectangle(lineA.x - (segLength - lineA.height), lineA.y, (segLength - lineA.height) + 1, 1);
				else lineA.y += td - segLength;
				
				FlxG.buffer.fillRect(lineA, segColor);
				if (lineB != null) FlxG.buffer.fillRect(lineB, segColor);
			}
			else if (td < 2*(width + (2*dfe)) - 1 + (height + (2*dfe) - 1))
			{
				td -= (width + (2*dfe) - 1) + (height + (2*dfe) - 1);
				
				lineA.width = Math.min(segLength, td);
				lineA.height = 1;
				lineA.x += (width - 1) + dfe - lineA.width + 1;
				lineA.y += (height - 1) + dfe;
				
				if (lineA.width < segLength) lineB = new Rectangle(lineA.x + lineA.width - 1, lineA.y - (segLength - lineA.width), 1, (segLength - lineA.width) + 1);
				else lineA.x += -(td - segLength);
				
				FlxG.buffer.fillRect(lineA, segColor);
				if (lineB != null) FlxG.buffer.fillRect(lineB, segColor);
			}
			else
			{
				td -= 2*(width + (2*dfe) - 1) + (height + (2*dfe) - 1);
				
				lineA.width = 1;
				lineA.height = Math.min(segLength, td);
				lineA.x += -dfe;
				lineA.y += (height-1) + dfe - lineA.height + 1;
				
				if (lineA.height < segLength) lineB = new Rectangle(lineA.x, lineA.y + lineA.height - 1, (segLength - lineA.height) + 1, 1);
				else lineA.y += -(td - segLength);
				
				FlxG.buffer.fillRect(lineA, segColor);
				if (lineB != null) FlxG.buffer.fillRect(lineB, segColor);
			}
		}
	}
}