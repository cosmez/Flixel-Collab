package example
{
	import flash.geom.Point;
	import org.flixel.*;
	import neoart.flod.*;
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	import collab.GameSelectState;
	import collab.IUnloadable;
	
	// Yoooo
	public class PlatformerDemoState extends FlxState implements IUnloadable
	{
		// lol
		private var player:Player;
		private var map:FlxTilemap;
		private var modProcessor:ModProcessor;
		private var path:Vector.<Point>;
		
		
		
		override public function create():void
		{
			map = new FlxTilemap();
			map.loadMap(new Resources.MAP_TEST_MAP, Resources.GFX_TEST_TILES, 16, 16, true);
			map.collideIndex = 2;
			add(map);
			
			player = new Player(200, 200);
			add(player);
			
			FlxG.follow(player, 1.0);
			FlxG.followBounds(0, 0, map.width, map.height, true);
			
			modProcessor = new ModProcessor();
			//playSong();
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