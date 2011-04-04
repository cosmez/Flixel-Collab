package collab
{
	import org.flixel.*;

	
	
	/**
	 * This class is the pause menu that appears on the Game Select screen.
	 * Currently, it's just an exact copy of FlxPause.
	 */
	public class GameSelectPause extends FlxGroup
	{
		/**
		 * Constructor.
		 */
		public function GameSelectPause()
		{
			super();
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			var w:uint = 80;
			var h:uint = 92;
			x = (FlxG.width-w)/2;
			y = (FlxG.height-h)/2;
			
			var s:FlxSprite;
			s = new FlxSprite().createGraphic(w,h,0xaa000000,true);
			s.solid = false;
			add(s,true);
			
			(add(new FlxText(0,0,w,"this game is"),true) as FlxText).alignment = "center";
			add((new FlxText(0,10,w,"PAUSED")).setFormat(null,16,0xffffff,"center"),true);
			
			s = new FlxSprite(4,36,Resources.ImgKeyP);
			s.solid = false;
			add(s,true);
			
			add(new FlxText(16,36,w-16,"Pause Game"),true);
			
			s = new FlxSprite(4,50,Resources.ImgKey0);
			s.solid = false;
			add(s,true);
			
			add(new FlxText(16,50,w-16,"Mute Sound"),true);
			
			s = new FlxSprite(4,64,Resources.ImgKeyMinus);
			s.solid = false;
			add(s,true);
			
			add(new FlxText(16,64,w-16,"Sound Down"),true);
			
			s = new FlxSprite(4,78,Resources.ImgKeyPlus);
			s.solid = false;
			add(s,true);
			
			add(new FlxText(16, 78, w - 16, "Sound Up"), true);
		}
	}
}