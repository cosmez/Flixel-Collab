package 
{
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
    [Frame(factoryClass = "Preloader")]
	
	import example.PlatformerPlayState; // Starting state
	
	import org.flixel.*;
	import collab.*;
	import collab.storage.GameStorage;

	

    public class FlixelCollab extends FlxGame
    {
		/**
		 * The class that starts up first when the game is compiled. Goes to game
		 * select screen by default. Set it to your game class to shortcut past it!
		 */
		private static const startingState:Class = GameSelectState; // Change GameSelectState to be your game's FlxState class!
																	// (e.g, try example.PlatformerPlayState)
		
		
		// Color Palette
		public static const BLACK:uint 		 = FlxU.getColor(  0,   0,   0);
		public static const GREY:uint 		 = FlxU.getColor(157, 157, 157);
		public static const WHITE:uint 		 = FlxU.getColor(255, 255, 255);
		public static const RED:uint 		 = FlxU.getColor(190,  38,  51);
		public static const PINK:uint 		 = FlxU.getColor(224, 111, 139);
		public static const DARK_BROWN:uint  = FlxU.getColor( 73,  60,  43);
		public static const BROWN:uint 		 = FlxU.getColor(164, 100,  34);
		public static const ORANGE:uint		 = FlxU.getColor(235, 137,  49);
		public static const PALE_YELLOW:uint = FlxU.getColor(247, 226, 107);
		public static const TEAL:uint  	     = FlxU.getColor( 47,  72,  78);
		public static const GREEN:uint 	     = FlxU.getColor( 68, 137,  26);
		public static const LIGHT_GREEN:uint = FlxU.getColor(163, 206,  39);
		public static const DARK_BLUE:uint   = FlxU.getColor( 27,  38,  50);
		public static const BLUE:uint 		 = FlxU.getColor(  0,  87, 132);
		public static const LIGHT_BLUE:uint  = FlxU.getColor( 49, 162, 242);
		public static const PALE_BLUE:uint   = FlxU.getColor(178, 220, 239);
		
		public static const PAL_0:uint  = BLACK;
		public static const PAL_1:uint  = GREY;
		public static const PAL_2:uint  = WHITE;
		public static const PAL_3:uint  = RED;
		public static const PAL_4:uint  = PINK;
		public static const PAL_5:uint  = DARK_BROWN;
		public static const PAL_6:uint  = BROWN;
		public static const PAL_7:uint  = ORANGE;
		public static const PAL_8:uint  = PALE_YELLOW;
		public static const PAL_9:uint  = TEAL;
		public static const PAL_10:uint = GREEN;
		public static const PAL_11:uint = LIGHT_GREEN;
		public static const PAL_12:uint = DARK_BLUE;
		public static const PAL_13:uint = BLUE;
		public static const PAL_14:uint = LIGHT_BLUE;
		public static const PAL_15:uint = PALE_BLUE;
		
		
		
		private static var flashWipe:FlxTransition;
		private static var fadeWipe:FlxTransition;
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
			
			// Set the default screen transitions (ones used ingame) to be different (no partial transparency!)
			FlxG.flash = new WipeIn();
			FlxG.fade = new WipeOut();
			
			// Set up our custom flash/fade.
			flashWipe = new WipeIn();
			fadeWipe = new WipeOut();
			
			// Set up our custom pause menus.
			pause = new CollabGamePause();
			altPause = new GameSelectPause();
			
			// Shortcut to gamestate if set.
			if (_state as GameSelectState != null)
			{
				swapTransitions();
				swapPauses();
			}
			
			// Make the framerate while paused be not shitty.
			FlxG.frameratePaused = 60;
        }
		
		
		
		/**
		 * Call this to get the current instiated storage system.  GameStorage has all you need for saving/loading
		 * games, setting persistent data values, serializing states, etc.
		 * 
		 * @return	Instance of our storage system.
		 */
		static public function getStorage():GameStorage { return _storage; }
		
		
		
		override public function switchState(State:FlxState):void
		{
			// Do special stuff if transitioning to or from Game Select State.
			if (_state as GameSelectState != null)
			{
				FlxG.mouse.hide();
				
				FlxG.unpauseOnFocus = false;
				
				flashWipe = new WipeIn();
				fadeWipe = new WipeOut();
				
				swapTransitions();
				swapPauses();
			}
			else if (State as GameSelectState != null)
			{
				if (!altPause.active) { FlxG.log("ERROR: ONLY PAUSE MENU CAN SWITCH BACK TO GAME SELECT STATE."); return; }
				
				FlxG.pausingEnabled = true;
				FlxG.unpauseOnFocus = true;
				FlxG.pause = false;
				
				swapTransitions();
				swapPauses();
			}
			
			super.switchState(State);
		}
		
		
		
		/**
		 * Internal FlixelCollab function. Don't call this!
		 */
		public static function swapTransitions():void
		{
			var swapTransition:FlxTransition = FlxG.fade;
			FlxG.fade = fadeWipe;
			fadeWipe = swapTransition;
			
			swapTransition = FlxG.flash;
			FlxG.flash = flashWipe;
			flashWipe = swapTransition;
		}
		
		/**
		 * Internal FlixelCollab function. Don't call this!
		 */
		public static function swapPauses():void
		{
			var swapPause:FlxGroup = pause;
			pause = altPause;
			altPause = swapPause;
		}
    }
}
