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
		 * How far along we are in the effect (in seconds).
		 */
		protected var _progress:Number;
		
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
			_progress = 0.0;
			_inProgress = true;
		}
		
		
		
		override public function update():void
		{
			super.update();
			
			// Updates _progress according to FlxG.elapsed.
			if (!_inProgress) return;
			
			if (_progress == _duration) finish();
			else
			{
				_progress += FlxG.elapsed;
				if (_progress >= _duration) _progress = _duration;
			}
		}
		
		
		
		/**
		 * Sets this screen effect to its finished state. Returns false if not started or already finished.
		 */
		public function finish():Boolean
		{
			if (!exists || !_inProgress) return false;
			
			_inProgress = false;
			_progress = _duration;
			
			if (_complete != null)
			{
				_complete();
				_complete = null;
			}
			
			return true;
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
