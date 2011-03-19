package ace
{
	import org.flixel.*;
	
	// Yoooo
	public class Player extends FlxSprite
	{
		// 
		private var walkSpeed :Number = 100.0;
		
		
		
		public function Player(X:int, Y:int)
		{
			super(X, Y);
			
			loadGraphic(Resources.GFX_COWBOY, true, true, 12, 16);
			
			addAnimation("idle", [0], 20, true);
			
			solid = true;
			acceleration.y = 500;
		}
		
		
		
		override protected function updateMotion():void
		{
			var walkDir:int = 0;
			
			if (FlxG.keys.pressed("LEFT")) walkDir -= 1;
			if (FlxG.keys.pressed("RIGHT")) walkDir += 1;
			
			velocity.x = 0;
			if (walkDir != 0)
			{
				velocity.x = walkDir * walkSpeed;
				
				if (walkDir == 1) facing = RIGHT;
				else facing = LEFT;
			}
			
			if (FlxG.keys.justPressed("X") && onFloor) velocity.y = -220;
			play("idle");
			
			super.updateMotion();
		}
		
		
		
		// THIS FUNCTION MUST BE DEFINED AND CALLED BEFORE SWITCHING STATES!!!
		public function unload():void
		{
			
		}
	}
}