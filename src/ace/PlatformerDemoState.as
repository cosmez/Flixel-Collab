package ace
{
	import org.flixel.*;
	import neoart.flod.*;
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	import collab.*;
	
	// Yoooo
	public class PlatformerDemoState extends FlxState implements IUnloadable
	{
		// lol
		private var player:Player;
		private var map:FlxTilemap;
		private var modProcessor:ModProcessor;
		
		
		
		override public function create():void
		{
			map = new FlxTilemap();
			map.loadMap(new ace.Resources.MAP_TEST_MAP, ace.Resources.GFX_TEST_TILES, 16, 16);
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
			
			FlxU.collide(player, map);
		}
		
		
		
		private function playSong():void
		{
			//	1) First we get the module into a ByteArray
			var stream:ByteArray = new ace.Resources.BGM_SONG() as ByteArray;
			
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
		}
	}
}