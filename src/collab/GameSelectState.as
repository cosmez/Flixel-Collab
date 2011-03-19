package collab
{
	import flash.media.SoundTransform;
	import org.flixel.*;
	import org.flixel.data.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import neoart.flod.*;
	import flash.utils.ByteArray;
	
	// The games themselves!
	import ace.PlatformerDemoState;
	
	
	
	// The GameSelectState is where the game starts at!
	public class GameSelectState extends FlxState implements IUnloadable
	{
		
		// Variables
		private var modProcessor:ModProcessor;
		public var songVolume:Number;
		private var startingGame :Boolean;
		//private var testSprite :FlxSprite;
		private var games:Vector.<Vector.<CollabGame>>;
		private var selectedGameIndices:FlxPoint;
		private var gameButtons:FlxGroup;
		
		// Preview area stuff.
		private var gameInfoBoxSprite:FlxSprite;
		private var gamePreviewSprite:FlxSprite;
		private var gameNameText:FlxText;
		private var gameAuthorText:FlxText;
		private var gameDescriptionText:FlxText;
		
		private var selectorSprite:FlxSprite;
		
		
		
		override public function create() :void
		{
			// Disable pausing on the game select screen.
			FlxG.pausingEnabled = false;
			
			// First of all, we make our ArcadeGameObjects.
			games = new Vector.<Vector.<CollabGame>>(2, true);
			games[0] = new Vector.<CollabGame>(3, true);
			games[1] = new Vector.<CollabGame>(3, true);
			
			games[0][0] = new CollabGame(null, "FUCKR", "morganq", "lolLOL");
			games[0][1] = new CollabGame(null, "Supa-Shmup", "kibo", "Pew! Pew! Pew!");
			games[0][2] = new CollabGame(null, "Zombie Dating Sim", "skiffles", "Hey, I said that I WASN'T making a game for this.");
			games[1][0] = new CollabGame(null, "Rainyvania", "Zenka", "Are you a bad enough dude to find the upgrades?");
			games[1][1] = new CollabGame(ace.PlatformerDemoState, "FlxCrawler", "Ace20", "A simple, fun dungeon crawler game!");
			games[1][2] = new CollabGame(null, "Eden Planet", "cai", "Natives and monkeys and pirates, oh my!");
			
			selectedGameIndices = new FlxPoint(-1,-1);
			
			// Add the scrolling background.
			var bg:FlxBackdrop = new FlxBackdrop(Resources.GFX_GAME_SELECT_BACKDROP);
			bg.velocity = new FlxPoint(40, 30);
			bg.solid = false;
			//bg.alpha = 0.8;
			//TweenMax.to(bg, 2.0, { alpha: 0.4, ease:Sine.easeInOut, repeat: -1, yoyo: true } );
			add(bg);
			
			// Add in the game info box.
			gameInfoBoxSprite = new FlxSprite(FlxG.width - 130, FlxG.height - 205, Resources.GFX_GAME_INFO_BOX);
			gameInfoBoxSprite.solid = false;
			add(gameInfoBoxSprite);
			
			// Make the animated preview box.
			gamePreviewSprite = new FlxSprite(gameInfoBoxSprite.x + 5, gameInfoBoxSprite.y + 5, Resources.GFX_GAME1_PREVIEW1);
			gamePreviewSprite.solid = false;
			add(gamePreviewSprite);
			
			// Make all the game info text stuff.
			gameNameText = new FlxText(gameInfoBoxSprite.x, gamePreviewSprite.y + gamePreviewSprite.height + 2, 130);
			gameNameText.setFormat(null, 10, FlxU.getColor(227, 255, 255), "center");
			gameNameText.solid = false;
			add(gameNameText);
			
			gameAuthorText = new FlxText(gameInfoBoxSprite.x, gameNameText.y + 13, 130);
			gameAuthorText.setFormat(null, 8, 0xffcccccc, "center");
			gameAuthorText.solid = false;
			add(gameAuthorText);
			
			gameDescriptionText = new FlxText(gameInfoBoxSprite.x + 10, gameAuthorText.y + 20, 130 - 20);
			gameDescriptionText.setFormat(null, 8, 0xffffffff, "left");
			gameDescriptionText.solid = false;
			add(gameDescriptionText);
			
			// Make buttons for each game!
			gameButtons = new FlxGroup();
			var bOffset:FlxPoint = new FlxPoint(12, 33);
			gameButtons.add(new FlxSprite(bOffset.x, bOffset.y, Resources.GFX_GAME1_ICON), true);
			gameButtons.add(new FlxSprite(bOffset.x + 80 + 8, bOffset.y, Resources.GFX_GAME2_ICON), true);
			gameButtons.add(new FlxSprite(bOffset.x, bOffset.y + 60 + 8, Resources.GFX_GAME3_ICON), true);
			gameButtons.add(new FlxSprite(bOffset.x + 80 + 8, bOffset.y + 60 + 8, Resources.GFX_GAME4_ICON), true);
			gameButtons.add(new FlxSprite(bOffset.x, bOffset.y + 120 + 16, Resources.GFX_GAME5_ICON), true);
			gameButtons.add(new FlxSprite(bOffset.x + 80 + 8, bOffset.y + 120 + 16, Resources.GFX_GAME6_ICON), true);
			add(gameButtons);
			
			// Add the logo text ("Flixel Arcade!").
			var logoText:FlxText = new FlxText(0, 4, FlxG.width, "Flixel Collab!");
			logoText.setFormat(null, 16, FlxU.getColor(192, 192, 255), "center", FlxU.getColor(0, 0, 0, 0.5));
			logoText.shadow = 1;
			logoText.solid = false;
			add(logoText);
			
			// Add the selector sprite.
			selectorSprite = new FlxSprite(0, 0, Resources.GFX_GAME_SELECTOR);
			add(selectorSprite);
			
			// Update game selection.
			updateSelectedGame();
			
			// Fade in from black.
			FlxG.flash.start(0xff000000, 0.6, null, true);
			
			// Music!
			modProcessor = new ModProcessor();
			playSong();
			
			startingGame = false;
			FlxG.mouse.show();
		}
		
		
		
		override public function update():void
		{
			selectorSprite.alpha = 0.7 + (Math.random() * 0.3);
			
			if (!startingGame)
			{
				if (FlxG.keys.justPressed("LEFT") && selectedGameIndices.x > 0)
				{
					selectedGameIndices.x--;
					updateSelectedGame();
				}
				if (FlxG.keys.justPressed("RIGHT") && selectedGameIndices.x < games.length - 1)
				{
					selectedGameIndices.x++;
					updateSelectedGame();
				}
				if (FlxG.keys.justPressed("UP") && selectedGameIndices.y > 0)
				{
					selectedGameIndices.y--;
					updateSelectedGame();
				}
				if (FlxG.keys.justPressed("DOWN") && selectedGameIndices.y < games[0].length - 1)
				{
					selectedGameIndices.y++;
					updateSelectedGame();
				}
				
				if (FlxG.keys.justPressed("ENTER") && games[selectedGameIndices.x][selectedGameIndices.y].gameClass != null)
				{
					FlxG.fade.start(0xff000000, 0.6, null, true);
					TweenMax.to(this, 0.6, { songVolume: 0.0, onUpdate: updateSongVolume, onComplete: startGame } );
					startingGame = true;
					FlxG.play(Resources.SFX_CONFIRM);
				}
			}
			
			super.update();
		}
		
		
		
		private function startGame():void
		{
			var game:CollabGame = games[selectedGameIndices.x][selectedGameIndices.y];
			FlxG.pausingEnabled = true;
			unload();
			FlxG.mouse.hide();
			FlxG.state = new game.gameClass();
		}
		
		
		
		private function updateSelectedGame():void
		{
			if (selectedGameIndices == null) return;
			
			var instantSwitch:Boolean = false;
			if (selectedGameIndices.x == -1 || selectedGameIndices.y == -1)
			{
				selectedGameIndices.x = 0;
				selectedGameIndices.y = 0;
				instantSwitch = true;
			}

			gameNameText.text = games[selectedGameIndices.x][selectedGameIndices.y].name;
			gameAuthorText.text = "By: " + games[selectedGameIndices.x][selectedGameIndices.y].author;
			gameDescriptionText.text = games[selectedGameIndices.x][selectedGameIndices.y].description;
			
			selectorSprite.x = (gameButtons.members[(selectedGameIndices.y * games.length) + (selectedGameIndices.x % games.length)] as FlxSprite).x - 4;
			selectorSprite.y = (gameButtons.members[(selectedGameIndices.y * games.length) + (selectedGameIndices.x % games.length)] as FlxSprite).y - 4;
			
			if (!instantSwitch) FlxG.play(Resources.SFX_MOVE_CURSOR, 0.6);
		}
		
		
		
		private function playSong():void
		{
			//	1) First we get the module into a ByteArray
			var stream:ByteArray = new Resources.BGM_SONG() as ByteArray;
			
			//	2) Load the song (now converted into a ByteArray) into the ModProcessor
			//	This returns true on success, meaing the module was parsed successfully
			
			if (modProcessor == null) modProcessor = new ModProcessor();
			
			if (modProcessor.load(stream))
			{
				//	Will the song loop at the end? (boolean)
				modProcessor.loopSong = true;
				
				//	3) Play it!
				modProcessor.play();
				modProcessor.soundChannel.soundTransform = new SoundTransform(0.6);
				songVolume = modProcessor.soundChannel.soundTransform.volume;
				//FlxG.music._sound = modProcessor.sound;
			}
		}
		
		private function updateSongVolume():void
		{
			if (!modProcessor.isPlaying) return;
			
			modProcessor.soundChannel.soundTransform = new SoundTransform(songVolume);
		}
		
		
		
		public function unload():void
		{
			//testSprite = null;
			games[0][0] = null;
			games[0][1] = null;
			games[0][2] = null;
			games[1][0] = null;
			games[1][1] = null;
			games[1][2] = null;
			games = null;
			
			//TweenMax.killTweensOf(modProcessor.soundChannel.soundTransform, true, { volume:0.0 } );
			modProcessor.stop();
			modProcessor.song = null;
			modProcessor = null;
		}
	}
}