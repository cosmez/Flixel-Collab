package collab
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class FlxWipeOut extends FlxTransition
	{
		public static const TOP_TO_BOTTOM:uint = 0;
		
		public var wipeType:uint;
		protected var _progressTimer:Number;
		
		
		public function FlxWipeOut(WipeType:uint = TOP_TO_BOTTOM)
		{
			super();
			
			wipeType = WipeType;
		}
		
		
		
		override public function update():void
		{
			if (_progressTimer > _duration)
			{
				finish();
			}
			
			_progressTimer += FlxG.elapsed;
		}
		
		
		
		override public function render():void
		{
			switch (wipeType)
			{
				case TOP_TO_BOTTOM:
					var rect:Rectangle = new Rectangle(0, 0, FlxG.width, (_progressTimer * FlxG.height) / _duration);
					FlxG.buffer.fillRect(rect, FlixelCollab.ARNE_PALETTE_BLACK);
					break;
			}
		}
		
		
		
		// Make this be setup() instead?
		override protected function setup():void
		{
			_progressTimer = 0.0;
		}
	}
}