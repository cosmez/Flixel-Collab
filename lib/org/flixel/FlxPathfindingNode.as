package org.flixel
{
	
	/**
	* ...
	* @author Vexhel
	*/
	public class FlxPathfindingNode
	{
		public static const UNPROCESSED:int = 0;
		public static const OPEN:int = 1;
		public static const CLOSED:int = 2;
		
		public var x:uint;
		public var y:uint;
		public var walkable:Boolean;
		
		public var g:int = 0;
		public var h:int = 0;
		public var f:int = 0;
		public var processedState:int = UNPROCESSED;
		//public var cost:int;
		public var parent:FlxPathfindingNode = null;
		
		

		public function FlxPathfindingNode(x:int, y:int, walkable:Boolean = true)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
		
		
		public function reset():void
		{
			g = 0;
			h = 0;
			f = 0;
			processedState = UNPROCESSED;
			parent = null;
		}
	}
}

