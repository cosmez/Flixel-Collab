package 
{
	import org.flixel.*;
	import collab.*;
	import collab.storage.GameStorage ;
	
	import example.PlatformerTitleState ;

	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
    [Frame(factoryClass="Preloader")]

    public class FlixelCollab extends FlxGame
    {
		public static const
			ARNE_PALETTE_0:uint  = FlxU.getColor(  0,   0,   0), // BLACK
			ARNE_PALETTE_1:uint  = FlxU.getColor(157, 157, 157), // GREY
			ARNE_PALETTE_2:uint  = FlxU.getColor(255, 255, 255), // WHITE
			ARNE_PALETTE_3:uint  = FlxU.getColor(190,  38,  51), // RED
			ARNE_PALETTE_4:uint  = FlxU.getColor(224, 111, 139), // PINK
			ARNE_PALETTE_5:uint  = FlxU.getColor( 73,  60,  43), // DARK BROWN
			ARNE_PALETTE_6:uint  = FlxU.getColor(164, 100,  34), // BROWN
			ARNE_PALETTE_7:uint  = FlxU.getColor(235, 137,  49), // ORANGE
			ARNE_PALETTE_8:uint  = FlxU.getColor(247, 226, 107), // PALE YELLOW
			ARNE_PALETTE_9:uint  = FlxU.getColor( 47,  72,  78), // TEAL
			ARNE_PALETTE_10:uint = FlxU.getColor( 68, 137,  26), // GREEN
			ARNE_PALETTE_11:uint = FlxU.getColor(163, 206,  39), // LIGHT GREEN
			ARNE_PALETTE_12:uint = FlxU.getColor( 27,  38,  50), // DARK BLUE
			ARNE_PALETTE_13:uint = FlxU.getColor(  0,  87, 132), // BLUE
			ARNE_PALETTE_14:uint = FlxU.getColor( 49, 162, 242), // LIGHT BLUE
			ARNE_PALETTE_15:uint = FlxU.getColor(178, 220, 239); // PALE BLUE
		
		public static const
			ARNE_PALETTE_BLACK:uint  	  = ARNE_PALETTE_0,
			ARNE_PALETTE_GREY:uint  	  = ARNE_PALETTE_1,
			ARNE_PALETTE_WHITE:uint  	  = ARNE_PALETTE_2,
			ARNE_PALETTE_RED:uint  		  = ARNE_PALETTE_3,
			ARNE_PALETTE_PINK:uint  	  = ARNE_PALETTE_4,
			ARNE_PALETTE_DARK_BROWN:uint  = ARNE_PALETTE_5,
			ARNE_PALETTE_BROWN:uint  	  = ARNE_PALETTE_6,
			ARNE_PALETTE_ORANGE:uint	  = ARNE_PALETTE_7,
			ARNE_PALETTE_PALE_YELLOW:uint = ARNE_PALETTE_8,
			ARNE_PALETTE_TEAL:uint  	  = ARNE_PALETTE_9,
			ARNE_PALETTE_GREEN:uint 	  = ARNE_PALETTE_10,
			ARNE_PALETTE_LIGHT_GREEN:uint = ARNE_PALETTE_11,
			ARNE_PALETTE_DARK_BLUE:uint   = ARNE_PALETTE_12,
			ARNE_PALETTE_BLUE:uint 		  = ARNE_PALETTE_13,
			ARNE_PALETTE_LIGHT_BLUE:uint  = ARNE_PALETTE_14,
			ARNE_PALETTE_PALE_BLUE:uint   = ARNE_PALETTE_15;
			
		internal static var fadeWipe:FlxTransition;
		internal static var flashWipe:FlxTransition;
		internal static var collabPause:FlxGroup;
		
		/**
		 * @private
		 * 
		 * The reference to our storage system.  This is initialized during startup of FlixelCollab.
		 */
		public var storage:GameStorage ;
		
        public function FlixelCollab()
        {
			// Start up the storage system -- has no dependencies on flixel, so it's cool
			storage = new GameStorage ("FlixelCollabI") ;
			
			// Make the game have 400x300 resolution at regular 2x pixel zoom. Start the game in PlayState.
			super(320, 240, GameSelectState, 2);
			//super (320, 240, PlatformerTitleState, 2) ;
			
			// Set up our custom fade/flash.
			fadeWipe = new FlxWipeOut();
			flashWipe = new FlxWipeIn();
			
			collabPause = new CollabPause();
			
			// Set the default screen transitions (ones used ingame) to be different (no partial transparency!)
			// FlxG.fade = new FlxWipe(); //in a sec
			// FlxG.flash = new FlxWipe();
			//pause = 
			
			swapTransitions();
			
			// Make the framerate while paused be not shitty.
			FlxG.frameratePaused = 60;
        }
		
		
		
		public static function switchToGameSelect():void
		{
			var state:IUnloadable = (FlxG.state as IUnloadable);
			
			if (state == null)
			{
				FlxG.log("ERROR: YOUR GAME STATE DOES NOT IMPLEMENT IUNLOADABLE!\nCANNOT SWITCH STATE.");
				return;
			}
			
			state.unload();
			
			FlxG.pausingEnabled = true;
			FlxG.pause = false;
			
			FlixelCollab.swapTransitions();
			FlixelCollab.swapPauses();
			
			FlxG.state = new GameSelectState();
			
			// Enable unpausing on regain focus.
			FlxG.unpauseOnFocus = true;
		}
		
		public static function switchToSelectedGame():void
		{
			var gsState:GameSelectState = (FlxG.state as GameSelectState);
			
			if (gsState == null)
			{
				FlxG.log("You can only switch to a game from the game select state.");
				return;
			}
			var gameClass:Class = gsState.selectedGame.gameClass;
			var state:IUnloadable = (FlxG.state as IUnloadable);
			if (state == null)
			{
				FlxG.log("ERROR: GAME SELECT DOES NOT IMPLEMENT IUNLOADABLE!\nCANNOT START SELECTED GAME.");
				return;
			}
			
			state.unload();
			FlxG.mouse.hide();
			
			swapTransitions();
			swapPauses();
			
			FlxG.state = new gameClass();
			
			// Make it so ingame pause menu won't disappear when refocusing.
			FlxG.unpauseOnFocus = false;
		}
		
		public static function swapTransitions():void
		{
			var swapTransition:FlxTransition = FlxG.fade;
			FlxG.fade = FlixelCollab.fadeWipe;
			FlixelCollab.fadeWipe = swapTransition;
			swapTransition = FlxG.flash;
			FlxG.flash = FlixelCollab.flashWipe;
			FlixelCollab.flashWipe = swapTransition;
		}
		
		public static function swapPauses():void
		{
			// swap pause!
			var swapPause:FlxGroup = FlxGame.pause;
			FlxGame.pause = FlixelCollab.collabPause;
			FlixelCollab.collabPause = swapPause;
		}
		
		/**
		 * Call this to get the current instiated storage system.  GameStorage has all you need for saving/loading
		 * games, setting persistent data values, serializing states, etc.
		 * 
		 * @return	Instance of our storage system.
		 */
		static public function getStorage():GameStorage
		{
			return (FlxG.game as FlixelCollab).storage ;
		}
    }
}
