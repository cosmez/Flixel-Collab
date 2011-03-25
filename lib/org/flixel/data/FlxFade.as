package org.flixel.data
{
	import org.flixel.*;
	
	/**
	 * This is a special effects utility class to help FlxGame do the 'fade' effect.
	 */
	public class FlxFade extends FlxTransition
	{	
		/**
		 * Constructor initializes the fade object
		 */
		public function FlxFade()
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
			
			if(alpha >= 1)
			{
				finish();
				alpha = 1;
			}
			alpha += FlxG.elapsed / _duration; // this used to be above the if
		}
		
		
		
		// This is alled automatically by start().
		override protected function setup():void
		{
			fill(_transitionColor);
			alpha = 0;
		}
	}
}
