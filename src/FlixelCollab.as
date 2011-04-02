package 
{
	import example.PlatformerPlayState;
	import org.flixel.*;
	import collab.*;
	import collab.storage.GameStorage;

	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
    [Frame(factoryClass="Preloader")]

    public class FlixelCollab extends FlxGame
    {
		private static const startingState:Class = PlatformerPlayState; // Change "GameSelectState" to be the Class of your game's FlxState!
																	// (try example.PlatformerPlayState)
		
		public static const ARNE_PALETTE_0:uint  = FlxU.getColor(  0,   0,   0); // BLACK;
		public static const ARNE_PALETTE_1:uint  = FlxU.getColor(157, 157, 157); // GREY
		public static const ARNE_PALETTE_2:uint  = FlxU.getColor(255, 255, 255); // WHITE
		public static const ARNE_PALETTE_3:uint  = FlxU.getColor(190,  38,  51); // RED
		public static const ARNE_PALETTE_4:uint  = FlxU.getColor(224, 111, 139); // PINK
		public static const ARNE_PALETTE_5:uint  = FlxU.getColor( 73,  60,  43); // DARK BROWN
		public static const ARNE_PALETTE_6:uint  = FlxU.getColor(164, 100,  34); // BROWN
		public static const ARNE_PALETTE_7:uint  = FlxU.getColor(235, 137,  49); // ORANGE
		public static const ARNE_PALETTE_8:uint  = FlxU.getColor(247, 226, 107); // PALE YELLOW
		public static const ARNE_PALETTE_9:uint  = FlxU.getColor( 47,  72,  78); // TEAL
		public static const ARNE_PALETTE_10:uint = FlxU.getColor( 68, 137,  26); // GREEN
		public static const ARNE_PALETTE_11:uint = FlxU.getColor(163, 206,  39); // LIGHT GREEN
		public static const ARNE_PALETTE_12:uint = FlxU.getColor( 27,  38,  50); // DARK BLUE
		public static const ARNE_PALETTE_13:uint = FlxU.getColor(  0,  87, 132); // BLUE
		public static const ARNE_PALETTE_14:uint = FlxU.getColor( 49, 162, 242); // LIGHT BLUE
		public static const ARNE_PALETTE_15:uint = FlxU.getColor(178, 220, 239); // PALE BLUE
		
		public static const ARNE_PALETTE_BLACK:uint  	  = ARNE_PALETTE_0;
		public static const ARNE_PALETTE_GREY:uint  	  = ARNE_PALETTE_1;
		public static const ARNE_PALETTE_WHITE:uint  	  = ARNE_PALETTE_2;
		public static const ARNE_PALETTE_RED:uint  		  = ARNE_PALETTE_3;
		public static const ARNE_PALETTE_PINK:uint  	  = ARNE_PALETTE_4;
		public static const ARNE_PALETTE_DARK_BROWN:uint  = ARNE_PALETTE_5;
		public static const ARNE_PALETTE_BROWN:uint  	  = ARNE_PALETTE_6;
		public static const ARNE_PALETTE_ORANGE:uint	  = ARNE_PALETTE_7;
		public static const ARNE_PALETTE_PALE_YELLOW:uint = ARNE_PALETTE_8;
		public static const ARNE_PALETTE_TEAL:uint  	  = ARNE_PALETTE_9;
		public static const ARNE_PALETTE_GREEN:uint 	  = ARNE_PALETTE_10;
		public static const ARNE_PALETTE_LIGHT_GREEN:uint = ARNE_PALETTE_11;
		public static const ARNE_PALETTE_DARK_BLUE:uint   = ARNE_PALETTE_12;
		public static const ARNE_PALETTE_BLUE:uint 		  = ARNE_PALETTE_13;
		public static const ARNE_PALETTE_LIGHT_BLUE:uint  = ARNE_PALETTE_14;
		public static const ARNE_PALETTE_PALE_BLUE:uint   = ARNE_PALETTE_15;
			
		private static var fadeWipe:FlxTransition;
		private static var flashWipe:FlxTransition;
		private static var altPause:FlxGroup;
		
		/**
		 * @private
		 * 
		 * The reference to our storage system.  This is initialized during startup of FlixelCollab.
		 */
		private static var _storage:GameStorage;
		
		
		
        public function FlixelCollab()
        {
			// Start up the storage system -- has no dependencies on flixel, so it's cool
			_storage = new GameStorage("FlixelCollabI");
			
			// Make the game have 400x300 resolution at regular 2x pixel zoom. Start the game in PlayState.
			super(320, 240, startingState, 2);
			
			// gotta do this to instantiate the mouse graphic.
			FlxG.mouse.show();
			FlxG.mouse.hide();
			
			// Set the default screen transitions (ones used ingame) to be different (no partial transparency!)
			FlxG.fade = new WipeOut();
			FlxG.flash = new WipeIn();
			
			// Set up our custom fade/flash.
			fadeWipe = new WipeOut();
			flashWipe = new WipeIn();
			
			pause = new CollabPause();
			altPause = new GameSelectPause();
			
			if (startingState == GameSelectState)
			{
				swapTransitions();
				swapPauses();
			}
			
			// Make the framerate while paused be not shitty.
			FlxG.frameratePaused = 60;
        }
		
		
		
		override public function switchState(State:FlxState):void
		{
			if (_state as GameSelectState != null)
			{
				FlxG.mouse.hide();
			
				FlxG.unpauseOnFocus = false;
			
				swapTransitions();
				swapPauses();
			}
			else if (State as GameSelectState != null)
			{
				FlxG.pausingEnabled = true;
				FlxG.unpauseOnFocus = true;
				FlxG.pause = false;
			
				swapTransitions();
				swapPauses();
			}
			
			super.switchState(State);
		}
		
		
		
		public static function swapTransitions():void
		{
			var swapTransition:FlxTransition = FlxG.fade;
			FlxG.fade = fadeWipe;
			fadeWipe = swapTransition;
			
			swapTransition = FlxG.flash;
			FlxG.flash = flashWipe;
			flashWipe = swapTransition;
		}
		
		
		
		public static function swapPauses():void
		{
			// swap pause!
			var swapPause:FlxGroup = pause;
			pause = altPause;
			altPause = swapPause;
		}
		
		
		
		/**
		 * Call this to get the current instiated storage system.  GameStorage has all you need for saving/loading
		 * games, setting persistent data values, serializing states, etc.
		 * 
		 * @return	Instance of our storage system.
		 */
		static public function getStorage():GameStorage
		{
			return _storage; //(FlxG.game as FlixelCollab).storage;
		}
    }
}
