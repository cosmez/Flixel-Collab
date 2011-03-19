package collab
{
	import org.flixel.*;
	import org.flixel.data.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class CollabPause extends FlxGroup
	{
		private var continueText:FlxText;
		private var quitText:FlxText;
		private var overlay:FlxSprite;
		private var continueSelected:Boolean;
		private var transitioning:Boolean;
		private var firstFrame:Boolean;
		
		
		
		public function CollabPause()
		{
			super();
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			var w:uint = 140;
			var h:uint = 90;
			
			// Does nothing. bug?
			
			var ox:int = (FlxG.width-w)/2;
			var oy:int = (FlxG.height-h)/2;
			
			// USE AN FLXBACKDROP!
			var bg:FlxBackdrop;
			bg = new FlxBackdrop(Resources.GFX_PAUSE_BACKDROP, 0.0, 0.0, false, false);
			bg.x = ox;
			bg.y = oy;
			//bg.velocity = new FlxPoint(40, 30);
			bg.solid = false;
			add(bg);
			
			continueText = new FlxText(ox, oy + 24, w, "CONTINUE");
			continueText.setFormat(null, 16, 0xffffff, "center");
			continueText.solid = false;
			add(continueText, true);
			
			quitText = new FlxText(ox, continueText.y + 22, w, "QUIT");
			quitText.setFormat(null, 16, 0xffffff, "center");
			quitText.solid = false;
			add(quitText, true);
			
			var s:FlxSprite = new FlxSprite(4, FlxG.height - 14, Resources.ImgKeyP);
			s.solid = false;
			add(s,true);
			
			add(new FlxText(16,FlxG.height - 14, w-16,"Pause Game"),true);
			
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
			
			overlay = (new FlxSprite()).createGraphic(FlxG.width, FlxG.height, FlxU.getColor(0, 0, 0, 1.0));
			overlay.alpha = 0.0;
			add(overlay, true);
			
			transitioning = false;
		}
		
		
		
		override public function update():void
		{
			super.update();
			
			if (!transitioning && !firstFrame)
			{
				if ( (FlxG.keys.justPressed("DOWN") && continueSelected)
					|| (FlxG.keys.justPressed("UP") && !continueSelected))
				{
					FlxG.play(Resources.SFX_MOVE_CURSOR, 0.4);
					continueSelected = !continueSelected;
				}
				
				if (FlxG.keys.justReleased("X") || FlxG.keys.justReleased("ESCAPE") || FlxG.keys.justReleased("P"))
				{
					FlxG.pausingEnabled = true;
					FlxG.pause = false;
				}
				else if (FlxG.keys.justReleased("ENTER") || FlxG.keys.justReleased("C"))
				{
					if (!continueSelected)
					{
						TweenMax.to(overlay, 0.6, { alpha: 1.0, onComplete: switchToGameSelect } );
						FlxG.play(Resources.SFX_CONFIRM);
						transitioning = true;
					}
					else
					{
						FlxG.pausingEnabled = true;
						FlxG.pause = false;
					}
				}
			}
			
			if (continueSelected)
			{
				continueText.color = FlxU.getColor(251, 238, 4);
				continueText.alpha = 0.7 + (Math.random() * 0.3);
				quitText.color = 0xffffffff;
				quitText.alpha = 1.0;
			}
			else
			{
				continueText.color = 0xffffffff;
				continueText.alpha = 1.0;
				quitText.color = FlxU.getColor(251, 238, 4);
				quitText.alpha = 0.7 + (Math.random() * 0.3);
			}
			
			firstFrame = false;
		}
		
		
		
		private function switchToGameSelect():void
		{
			var state:IUnloadable = (FlxG.state as IUnloadable);
			
			if (state != null)
			{
				state.unload();
				overlay.alpha = 0.0;
				FlxG.pausingEnabled = true;
				FlxG.pause = false;
				
				FlxG.state = new GameSelectState();
			}
		}
		
		
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X, Y);
			
			transitioning = false;
			firstFrame = true;
			continueSelected = true;
			FlxG.pausingEnabled = false;
			TweenMax.pauseAll();
			
			FlxG.play(Resources.SFX_OPEN_PAUSE);
		}
		
		
		
		override public function kill():void
		{
			TweenMax.resumeAll();
			FlxG.play(Resources.SFX_CANCEL);
		}
	}
}