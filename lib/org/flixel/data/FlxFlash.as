package org.flixel.data
{
	import org.flixel.*;
	
	/**
	 * This is a special effects utility class to help FlxGame do the 'flash' effect
	 */
	public class FlxFlash extends FlxTransition
	{
		/**
		 * Constructor for this flash effect
		 */
		public function FlxFlash()
		{
			super();
			createGraphic(FlxG.width,FlxG.height,0,true);
		}
		
		override public function finish():Boolean
		{
			if (!super.finish()) return false;
			
			exists = false;
			return true;
		}
		
		/**
		 * Animates this special effect
		 */
		override public function render():void
		{
			alpha = 1 - (_progress / _duration);
			super.render();
		}
		
		// This is alled automatically by start().
		override protected function setup():void //use setup() instead of reset()?
		{
			fill(_transitionColor);
			alpha = 1;
		}
	}
}
