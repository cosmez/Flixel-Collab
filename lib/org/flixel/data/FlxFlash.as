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
		
		/**
		 * Updates and/or animates this special effect
		 */
		override public function update():void
		{
			// if (!inProgress)
			// {
			// 	   final state of anim
			// }
			// else
			// {
			
			if(alpha <= 0)
			{
				finish();
				exists = false;
			}
			alpha -= FlxG.elapsed / _duration; // this used to be above the if
		}
		
		// This is alled automatically by start().
		override protected function setup():void //use setup() instead of reset()?
		{
			fill(_transitionColor);
			alpha = 1;
		}
	}
}
