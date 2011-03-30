package example
{
	import collab.storage.GameStorage;
	import example.storage.PlatformerGameData ;
	import example.storage.enemy.EnemyStateData ;
	
	import flash.geom.Point;
	import org.flixel.*;
	import neoart.flod.*;
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	import collab.GameSelectState;
	import collab.IUnloadable;
	
	// Yoooo
	public class PlatformerPlayState extends FlxState implements IUnloadable
	{
		// lol
		private var player:Player;
		private var enemies:FlxGroup ;
		private var map:FlxTilemap;
		private var modProcessor:ModProcessor;
		private var path:Vector.<Point>;
		
		public var storage:GameStorage ;
		
		public var gameData:PlatformerGameData ;
		
		override public function create():void
		{
			map = new FlxTilemap();
			map.loadMap(new Resources.MAP_TEST_MAP, Resources.GFX_TEST_TILES, 16, 16, true);
			map.collideIndex = 2;
			add(map);
			
			player = new Player(200, 200);
			add(player);
			
			enemies = new FlxGroup ;			
			add (enemies) ;
			
			FlxG.follow(player, 1.0);
			FlxG.followBounds(0, 0, map.width, map.height, true);
			
			modProcessor = new ModProcessor();
			//playSong();
			
			// Get a reference to the global storage mechanism
			storage = FlixelCollab.getStorage() ;
			
			// Set our sub-folder to be "PlatformerExampleGame"
			// (All values read/written will be private to this storage folder.)
			storage.setFolder ("PlatformerExampleGame") ;
			
			// Register our save game data class
			storage.registerGameData (PlatformerGameData) ;
			
			// Load game state data
			gameData = storage.readGameData (PlatformerGameData) ;
			
			// If no enemies are stored, then perform initial enemy initialization
			if (!gameData.trackedEnemies.length)
			{
				FlxG.log ("No enemies saved, so we're making new ones.") ;
				
				// Create 5 random enemies and place them throughout the level
				
				for (var i:int = 0; i < 5; i++)
				{
					var open:FlxPoint = findOpenSpot() ;
					
					// First we create the enemy state data.  This is what is saved/loaded into the save game.
					var enemyState:EnemyStateData = new EnemyStateData ;
					enemyState.loadInitialValues( { x: open.x, y: open.y } ) ;
					
					// Now, actually create an enemy
					var enemy:Enemy = new Enemy (enemyState) ;
				}
			} else
			{
				// re-create our enemies
				gameData.restoreTracked() ;
			}
			
			// Reposition our player to the start position
			player.x = gameData.playerPos.x ;
			player.y = gameData.playerPos.y ;
			
			saveGame() ;
		}
		
		
		
		override public function update():void
		{
			super.update();
			
			/*
			if (path != null)
			{
				for (var i:int = 0; i < path.length; i++)
					map.setTile(path[i].x, path[i].y, 0, true);
			}
			path = map.findPath(int(player.x / 16), int(player.y / 16), 30, 1, 6, 0, true, false, true);
			if (path != null)
			{
				for (i = 0; i < path.length; i++)
					map.setTile(path[i].x, path[i].y, 1, true);
			}
			*/
			
			FlxU.collide(player, map);
			
			FlxU.collide (enemies, map) ;
			
			FlxU.collide (player, enemies) ;
			
			if (FlxG.keys.justPressed ("ESCAPE"))
			{
				FlxG.state = new PlatformerTitleState ;
				saveGame() ;
			}
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
				//FlxG.music._sound = modProcessor.sound;
			}
		}
		
		public function getEnemyGroup():FlxGroup
		{
			return enemies ;
		}
		
		public function saveGame():void
		{
			gameData.playerPos.x = player.x ;
			gameData.playerPos.y = player.y ;
			
			// Save our game
			gameData.saveTracked() ;
			storage.writeGameData (gameData) ;			
		}
		
		private function getCollisionStatus (x:int, y:int, w:int, h:int):Boolean
		{
			for (var tx:int = x; tx < x + w; tx++)
				for (var ty:int = y; ty < y + h; ty++)
					if (map.getTile (tx, ty) >= map.collideIndex)
						return true ;
			return false ;
		}
		
		private function findOpenSpot():FlxPoint
		{
			var point:FlxPoint = new FlxPoint ;
			var open:Boolean = false ;
			while (!open)
			{
				var top:Boolean = FlxU.random() >= 0.5 ? true : false ;
				point.x = Math.floor (FlxU.random() * (map.widthInTiles - 1)) ;
				point.y = 0 ;
				if (top)
				{				
					// Walk from top to bottom until we find an empty spot
					for (var y:int = 4; y < map.heightInTiles - 4; y++)
					{
						if (!getCollisionStatus (point.x, y, 2, 2))
						{
							point.y = y ;
							open = true ;
						}
					}
				} else
				{
					// Walk from bottom to top yada yada
					for (y = map.heightInTiles - 4; y > 4; y--)
					{
						if (!getCollisionStatus (point.x, y, 2, 2))
						{
							point.y = y ;
							open = true ;
						}
					}
				}
			}
			
			point.x *= 16 ;
			point.y *= 16 ;
			
			return point ;
		}
		
		
		// THIS FUNCTION MUST BE DEFINED AND CALLED BEFORE SWITCHING STATES!!!
		public function unload():void
		{
			modProcessor.stop();
			modProcessor.song = null;
			modProcessor = null;
			
			map = null;
			player = null;
		}
	}
}