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
	import example.PlatformerDemoState;
	
	
	
	// The GameSelectState is where the game starts at!
	public class GameSelectState extends FlxState implements IUnloadable
	{
		// Variables
		private var modProcessor:ModProcessor;
		public var songVolume:Number;
		private var startingGame :Boolean;
		//private var testSprite :FlxSprite;
		private var games:Vector.<CollabGameInfo>;
		public var selectedGame:CollabGameInfo;
		private var selectedGameIndices:FlxPoint;
		private var gameIcons:FlxGroup;
		private var gameIconGrid:Vector.<Vector.<FlxObject>>;
		
		// Preview area stuff.
		private var titleChars:FlxGroup;
		private var titleCharShadows:FlxGroup;
		private var gameInfoBoxSprite:FlxSprite;
		private var gamePreviewSprite:FlxSprite;
		private var gameNameText:FlxText;
		private var gameAuthorText:FlxText;
		private var gameDescriptionText:FlxText;
		
		private var titleAnimCounter:Number = 0;
		
		private var selectorSprite:SelectorSprite;
		private var mouseMode:Boolean = false;
		private var prevMousePos:FlxPoint;
		
		
		
		override public function create() :void
		{
			// First of all, we make our ArcadeGameObjects.
			games = new Vector.<CollabGameInfo>(6, true);
			
			games[0] = new CollabGameInfo(null, null, "FUCKR", "morganq", "lolLOL");
			games[1] = new CollabGameInfo(null, null, "Supa-Shmup", "kibo", "Pew! Pew! Pew!");
			games[2] = new CollabGameInfo(null, null, "Zombie Dating Sim", "skiffles", "Hey, I said that I WASN'T making a game for this.");
			games[3] = new CollabGameInfo(null, null, "Rainyvania", "Zenka", "Are you a bad enough dude to find the upgrades?");
			games[4] = new CollabGameInfo(example.PlatformerDemoState, Resources.GFX_GAME1_ICON, "FlxCrawler", "Ace20", "A simple, fun dungeon crawler game!");
			games[4].previewImages.push(Resources.GFX_GAME1_PREVIEW1);
			games[5] = new CollabGameInfo(null, null, "Eden Planet", "cai", "Natives and monkeys and pirates, oh my!");
			
			selectedGameIndices = new FlxPoint(-1,-1);
			
			// Add the scrolling background.
			var bg:FlxBackdrop = new FlxBackdrop(Resources.GFX_GAME_SELECT_BACKDROP, 40, 30, true, true, true);
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
			
			// Make icons for each game!
			gameIconGrid = new Vector.<Vector.<FlxObject>>(2);
			gameIconGrid[0] = new Vector.<FlxObject>(3);
			gameIconGrid[1] = new Vector.<FlxObject>(3);
			gameIcons = new FlxGroup();
			
			var iconOffset:FlxPoint = new FlxPoint(12, 33);
			for (var i:int = 0; i < games.length; i++)
			{
				var curGameInfo:CollabGameInfo = games[i];
				if (curGameInfo == null) continue;
				
				var icon:FlxSprite;
				if (curGameInfo.iconImage != null)
					icon = new FlxSprite(iconOffset.x + ((80 + 8) * (i % 2)), iconOffset.y + ((60 + 8) * int(i / 2)), curGameInfo.iconImage);
				else
					icon = new FlxSprite(iconOffset.x + ((80 + 8) * (i % 2)), iconOffset.y + ((60 + 8) * int(i / 2)), Resources.GFX_NO_GAME_ICON);
				
				gameIcons.add(icon);
				gameIconGrid[i % 2][int(i / 2)] = icon;
			}
			add(gameIcons);
			
			// Add the title text ("Flixel Collab!").
			var titleFont:FlxCaiBitmapFont = new FlxCaiBitmapFont(Resources.GFX_TITLE_FONT, 16, 17, 0, 0, FlxBitmapFont.TEXT_SET4 + ".:;!?\''()");
			titleChars = new FlxGroup();
			titleCharShadows = new FlxGroup();
			
			var titleString:String = "FLIXEL COLLAB!";
			var titleOffset:int = (FlxG.width - (titleString.length * 16)) / 2;
			for (i = 0; i < titleString.length; i++)
			{
				var char:String = titleString.charAt(i);
				var charSprite:FlxBitmapText = new FlxBitmapText(titleOffset + (16 * i), 8, titleFont, char);
				titleChars.add(charSprite, true);
				charSprite = new FlxBitmapText(titleOffset + (16 * i) + 1, 8, titleFont, char);
				charSprite.colorFont = false;
				charSprite.color = FlxU.getColor(24, 36, 48);
				titleCharShadows.add(charSprite, true);
			}
			add(titleCharShadows);
			add(titleChars);
			
			//var titleText:FlxBitmapFont = new FlxBitmapFont(Resources.GFX_TITLE_FONT, 16, 16, FlxBitmapFont.TEXT_SET4, 20, 0, 1);
			//titleText.width = FlxG.width;
			//titleText.setText("WOO HEY TESTING");
			//titleText.align = FlxBitmapFont.ALIGN_RIGHT;
			
			//var titleFont:org.flixel.cai.FlxBitmapFont = new org.flixel.cai.FlxBitmapFont(Resources.GFX_TITLE_FONT, 16, 17, 0, 0, org.flixel.FlxBitmapFont.TEXT_SET4);
			//var titleText:FlxBitmapText = new FlxBitmapText(0, 0, titleFont, "WOO! ALRIGHT SWEET!", "center", 0);
			//titleText.colorFont = true;
			//add(titleText);
			
			//var logoText:FlxText = new FlxText(0, 4, FlxG.width, "Flixel Collab!");
			//logoText.setFormat(null, 16, FlxU.getColor(192, 192, 255), "center", FlxU.getColor(0, 0, 0, 0.5));
			//logoText.shadow = 1;
			//logoText.solid = false;
			//add(logoText);
			
			// Add the selector sprite.
			selectorSprite = new SelectorSprite(0, 0, gameIconGrid[0][0].width, gameIconGrid[0][0].height);
			add(selectorSprite);
			
			// Update game selection.
			updateSelectedGame();
			
			// Fade in from black.
			FlxG.flash.start(0xff000000, 0.6, null, true);
			
			// Music!
			modProcessor = new ModProcessor();
			playSong();
			
			startingGame = false;
			prevMousePos = new FlxPoint(-1, -1);
			
			FlxG.mouse.show(); // gotta do this to instantiate the mouse graphic.
			FlxG.mouse.hide();
		}
		
		
		
		override public function update():void
		{
			super.update();
			
			titleAnimCounter += FlxG.elapsed;
			
			for (var i:int = 0; i < titleChars.members.length; i++)
			{
				var curCharSprite:FlxObject = titleChars.members[i] as FlxObject;
				//var curCharSprite:org.flixel.cai.FlxBitmapFont = titleChars.members[i] as org.flixel.cai.FlxBitmapFont;
				curCharSprite.y = 8 + (4 * Math.sin((titleAnimCounter * 4) + (i * 0.4)));
				
				(titleCharShadows.members[i] as FlxObject).y = curCharSprite.y + 1;
			}
			
			//selectorSprite.alpha = 0.7 + (Math.random() * 0.3);
			
			if (!startingGame)
			{
				// Set mouse mode to true or false.
				if (!mouseMode && prevMousePos.x != -1 && (FlxG.mouse.cursor.x != prevMousePos.x || FlxG.mouse.cursor.y != prevMousePos.y))
				{
					mouseMode = true;
					FlxG.mouse.show();
				}
				else if (mouseMode && (FlxG.keys.pressed("UP") || FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("LEFT") || FlxG.keys.pressed("RIGHT") || FlxG.keys.pressed("ENTER")))
				{
					mouseMode = false;
					FlxG.mouse.hide(); // ideally, FlxG.mouse.show(GFX_MOUSE_INACTIVE);
				}
				prevMousePos.x = FlxG.mouse.cursor.x;
				prevMousePos.y = FlxG.mouse.cursor.y;

				// Update screen based on player input.
				if (mouseMode)
				{
					if (FlxU.overlap(new FlxObject(FlxG.mouse.cursor.x, FlxG.mouse.cursor.y, 10, 10), gameIcons, onMouseOverlap))
					{
						// Mouse is overlapping an icon.
						updateSelectedGame();
						if (FlxG.mouse.justPressed()) startGame();
					}
				}
				else
				{
					if (FlxG.keys.justPressed("LEFT") && selectedGameIndices.x > 0)
					{
						selectedGameIndices.x--;
						updateSelectedGame();
					}
					if (FlxG.keys.justPressed("RIGHT") && selectedGameIndices.x < gameIconGrid.length - 1)
					{
						selectedGameIndices.x++;
						updateSelectedGame();
					}
					if (FlxG.keys.justPressed("UP") && selectedGameIndices.y > 0)
					{
						selectedGameIndices.y--;
						updateSelectedGame();
					}
					if (FlxG.keys.justPressed("DOWN") && selectedGameIndices.y < gameIconGrid[0].length - 1)
					{
						selectedGameIndices.y++;
						updateSelectedGame();
					}
					
					if (FlxG.keys.justPressed("ENTER")) startGame();
				}
			}
		}
		
		
		
		// Handles overlapping of mouse and icons.
		public function onMouseOverlap(Object1:FlxObject, Object2:FlxObject):Boolean
		{
			var foundIcon:Boolean = false;
			for (var i:int = 0; i < gameIconGrid.length; i++)
			{
				for (var j:int = 0; j < gameIconGrid[0].length; j++)
				{
					var curIcon:FlxObject = gameIconGrid[i][j];
					if (curIcon === Object2)
					{
						selectedGameIndices.x = i;
						selectedGameIndices.y = j;
						foundIcon = true;
						break;
					}
				}
				
				if (foundIcon) break;
			}
			
			return true;
		}
		
		
		
		private function startGame():void
		{
			if (selectedGame.gameClass == null) return;
			
			FlxG.fade.start(0xff000000, 0.6, null, true); // Can't do a fade in the final one
			TweenMax.to(this, 0.6, { songVolume: 0.0, onUpdate: updateSongVolume, onComplete: FlixelCollab.switchToSelectedGame } );
			selectorSprite.innerSpeed *= 8;
			selectorSprite.outerSpeed *= 2;
			selectorSprite.shouldFlash = true;
			startingGame = true;
			FlxG.play(Resources.SFX_CONFIRM);
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

			var gameInfo:CollabGameInfo = games[(selectedGameIndices.y * gameIconGrid.length) + selectedGameIndices.x];
			if (gameInfo == selectedGame) return;
			
			selectedGame = gameInfo;
			gameNameText.text = selectedGame.name;
			gameAuthorText.text = "By: " + selectedGame.author;
			gameDescriptionText.text = selectedGame.description;
			if (gameInfo.previewImages != null && selectedGame.previewImages.length != 0 && selectedGame.previewImages[0] != null)
				gamePreviewSprite.loadGraphic(selectedGame.previewImages[0]);
			else
				gamePreviewSprite.loadGraphic(Resources.GFX_NO_GAME_PREVIEW);
			
			selectorSprite.x = gameIconGrid[selectedGameIndices.x][selectedGameIndices.y].x;// - 4;
			selectorSprite.y = gameIconGrid[selectedGameIndices.x][selectedGameIndices.y].y;// - 4;
			
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
			for (var i:int = 0; i < games.length; i++) { games[i] = null; gameIconGrid[i % 2][int(i / 2)] = null; }
			games = null;
			
			//TweenMax.killTweensOf(modProcessor.soundChannel.soundTransform, true, { volume:0.0 } );
			modProcessor.stop();
			modProcessor.song = null;
			modProcessor = null;
		}
	}
}