package collab
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class WipeOut extends FlxTransition
	{
		public static const TOP_TO_BOTTOM:uint = 0;
		public static const BOTTOM_TO_TOP:uint = 1;
		public static const LEFT_TO_RIGHT:uint = 2;
		public static const RIGHT_TO_LEFT:uint = 3;
		
		public var wipeType:uint;
		
		
		
		public function WipeOut(WipeType:uint = TOP_TO_BOTTOM)
		{
			super();
			
			wipeType = WipeType;
		}
		
		
		
		override public function render():void
		{
			if (wipeType == TOP_TO_BOTTOM
				|| wipeType == BOTTOM_TO_TOP
				|| wipeType == LEFT_TO_RIGHT
				|| wipeType == RIGHT_TO_LEFT)
			{
				var rect:Rectangle;
				
				if (wipeType == TOP_TO_BOTTOM)
				{
					rect = new Rectangle(0, 0, FlxG.width, ((_progress * FlxG.height) / _duration));
				}
				else if (wipeType == BOTTOM_TO_TOP)
				{
					rect = new Rectangle(0, FlxG.height - ((_progress * FlxG.height) / _duration), FlxG.width);
					rect.height = FlxG.height - rect.y;
				}
				else if (wipeType == LEFT_TO_RIGHT)
				{
					rect = new Rectangle(0, 0, (_progress * FlxG.width) / _duration, FlxG.height);
				}
				else if (wipeType == RIGHT_TO_LEFT)
				{
					rect = new Rectangle(FlxG.width - ((_progress * FlxG.width) / _duration), 0, 0, FlxG.height);
					rect.width = FlxG.width - rect.x;
				}
				
				FlxG.buffer.fillRect(rect, _transitionColor);
			}
		}
		
		
		
		// Make this be setup() instead?
		override protected function setup():void
		{
			// nothing yetLOL
		}
	}
}