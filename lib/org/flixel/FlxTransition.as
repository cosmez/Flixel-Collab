package org.flixel
{
	/**
	 * This is a screen transition effect utility class to help with transitioning between states and stuff.
	 */
	public class FlxTransition extends FlxSprite
	{
		/**
		 * Whether or not the effect is currently running.
		 */
		protected var _inProgress:Boolean;
		
		/**
		 * How long the effect should last.
		 */
		protected var _duration:Number;
		
		/**
		 * The color this transition is going to / from.
		 */
		protected var _transitionColor:uint;
		
		/**
		 * Callback for when the effect is finished.
		 */
		protected var _complete:Function;
		
		
		
		/**
		 * Constructor initializes the screen transition object
		 */
		public function FlxTransition()
		{
			//super();
			
			x = 0;
			y = 0;
			//createGraphic(1,1,0);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			exists = false;
			solid = false;
			fixed = true;
		}
		
		/**
		 * Reset and trigger this special effect
		 * 
		 * @param	Color			The color you want to use
		 * @param	Duration		How long it should take to transition to the the screen
		 * @param	OnComplete		A function you want to run when the transition finishes
		 * @param	Force			Force the effect to reset
		 */
		public function start(Color:uint = 0xff000000, Duration:Number=1.0, OnComplete:Function=null, Force:Boolean=false):void
		{
			if (!Force && _inProgress) return;
			
			_transitionColor = Color;
			_duration = Duration;
			_complete = OnComplete;
			exists = true;
			setup();
			_inProgress = true;
		}
		
		/**
		 * Forces the transition to skip to its end.
		 */
		public function finish():void
		{
			_inProgress = false;
			
			if (_complete != null)
			{
				_complete();
				_complete = null;
			}
		}
		
		/**
		 * For initializing the transition after start() has been called.
		 */
		protected function setup():void
		{
			// Override this with your own code!
		}
		
		/**
		 * Stops and hides this screen effect.
		 */
		public function stop():void { exists = false; }
		
		public function inProgress():Boolean { return _inProgress; }
	}
}
