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
		 * Animates this special effect
		 */
		override public function render():void
		{
			alpha = _progress / _duration;
			super.render();
		}
		
		
		
		// This is alled automatically by start().
		override protected function setup():void
		{
			fill(_transitionColor);
			alpha = 0;
		}
	}
}
