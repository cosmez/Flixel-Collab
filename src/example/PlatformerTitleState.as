package example
{
	// We need IUnloadable so we always have unload() defined!
	import collab.IUnloadable;
	
	// Game save stuff from Collab
	import collab.storage.GameStorage ;
	
	// UI stuff from Collab
	import collab.ui.SelectorButton;
	
	// We wub you, Flixel
	import org.flixel.* ;
	
	// Storage class for game data
	import example.storage.PlatformerGameData ;
	
	/**
	 * A simple title state.  Implements game loading or starting a new game.
	 * 
	 * @author David Grace
	 */
	public class PlatformerTitleState extends FlxState implements IUnloadable 
	{
		private var _storage:GameStorage ;
		
		override public function create():void
		{
			super.create() ;
			
			// Get a reference to the global storage mechanism
			_storage = FlixelCollab.getStorage() ;
			
			// Set our sub-folder to be "PlatformerExampleGame"
			// (All values read/written will be private to this storage folder.)
			_storage.setFolder ("PlatformerExampleGame") ;
			
			// Register our save game data class
			_storage.registerGameData (PlatformerGameData) ;
			
			// Build a simple title screen			
			var title:FlxText = new FlxText (0, 30, FlxG.width, "Platformer Game") ;
			title.setFormat (null, 32, 0xFFFFFF00, "center", 0xFF555500) ;			
			add (title) ;
			
			var saveGamePresent:Boolean = _storage.gameDataExists (PlatformerGameData) ;
			
			// Create the new game button
			var newGameButtonNormal:FlxGroup = new FlxGroup ;
			newGameButtonNormal.add ((new FlxSprite (FlxG.width / 2 - 80, 150)).createGraphic (160, 20, 0xFF222222)) ;			
			newGameButtonNormal.add (new FlxText (0, 150, FlxG.width, "Start New Game").setFormat (null, 16, 0x555555, "center", 0x222222)) ;
			
			var newGameButtonLit:FlxGroup = new FlxGroup ;
			newGameButtonLit.add ((new FlxSprite (FlxG.width / 2 - 80, 150)).createGraphic (160, 20, 0xFF444444)) ;			
			newGameButtonLit.add (new FlxText (0, 150, FlxG.width, "Start New Game").setFormat (null, 16, 0xFFFFFF, "center", 0x555555)) ;
			
			var newGameSelector:SelectorButton = new SelectorButton (FlxG.width / 2 - 80, 150, 160, 20, newGameButtonNormal, newGameButtonLit, null, onNewGame) ;
			add (newGameSelector) ;
			
			// Create the continue game button
			var ContinueGameButtonNormal:FlxGroup = new FlxGroup ;
			ContinueGameButtonNormal.add ((new FlxSprite (FlxG.width / 2 - 80, 180)).createGraphic (160, 20, 0xFF222222)) ;			
			ContinueGameButtonNormal.add (new FlxText (0, 180, FlxG.width, "Continue Game").setFormat (null, 16, 0x555555, "center", 0x222222)) ;
			
			var ContinueGameButtonLit:FlxGroup = new FlxGroup ;
			ContinueGameButtonLit.add ((new FlxSprite (FlxG.width / 2 - 80, 180)).createGraphic (160, 20, 0xFF444444)) ;			
			ContinueGameButtonLit.add (new FlxText (0, 180, FlxG.width, "Continue Game").setFormat (null, 16, 0xFFFFFF, "center", 0x555555)) ;

			var ContinueGameButtonDisabled:FlxGroup = new FlxGroup ;
			ContinueGameButtonDisabled.add ((new FlxSprite (FlxG.width / 2 - 80, 180)).createGraphic (160, 20, 0xFF440000)) ;			
			ContinueGameButtonDisabled.add (new FlxText (0, 180, FlxG.width, "Continue Game").setFormat (null, 16, 0x990000, "center", 0x550000)) ;
			
			var continueGameSelector:SelectorButton = new SelectorButton (FlxG.width / 2 - 80, 180, 160, 20, ContinueGameButtonNormal, ContinueGameButtonLit, ContinueGameButtonDisabled, onContinueGame, saveGamePresent) ;
			add (continueGameSelector) ;
			
			// Always start with New Game selected
			SelectorButton.select (this.defaultGroup, newGameSelector) ;
			
			FlxG.mouse.show() ;
		}
		
		override public function update():void
		{
			super.update() ;
			
			// Handle the functionality of all the existing selector buttons
			SelectorButton.updateButtons(this.defaultGroup) ;
		}
		
		private function onNewGame():void
		{
			// We force a new game by clearing the PlatformerGameData from the save system
			_storage.clearGameData (PlatformerGameData) ;
			
			/*
			 * Alternately, you could do it this way:
			 * 
			 * storage.writeGameData (new PlatformGameData) ;
			 * 
			 * As this will write a blank PlatformGameData class to the save.
			 */
			
			// Annnnyway, go ahead and switch to the play state
			FlxG.state = new PlatformerPlayState ;
		}
		
		private function onContinueGame():void
		{
			// Just switch right to the play state.  Why no save game load?  Cuz that's all handled in the play state!
			FlxG.state = new PlatformerPlayState ;
		}
		
		public function unload():void
		{
			_storage = null ;
		}
	}

}