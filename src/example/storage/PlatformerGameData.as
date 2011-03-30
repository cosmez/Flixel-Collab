package example.storage
{
	import collab.storage.GameData ;
	import collab.storage.TrackedList ;
	
	import example.storage.enemy.EnemyStateData ;
	
	import org.flixel.* ;
	
	
	/**
	 * This class acts like a storage class for holding our game's global state and save data.
	 * 
	 * As long as we put variables in this class, it will be automatically saved (and read) when we engage the Collab
	 * game save mechanism.
	 * 
	 * @author David Grace
	 */
	public class PlatformerGameData extends GameData 
	{
		// A list of all enemies that are tracked in the save
		public var trackedEnemies:TrackedList ;
		
		// The number of bullets the player carries
		public var bullets:int ;
		
		public var playerPos:FlxPoint ;
		
		/**
		 * In the constructor, we must make sure that we load in the "sane" defaults, which would be used to start
		 * a new game.
		 */
		public function PlatformerGameData() 
		{
			// Call super, otherwise import stuff doesn't get registered!
			super() ;
			
			// Be sure to register any classes that might get tracked in this GameData OR in any of its tracked objects!			
			registerClass (EnemyStateData) ;
			registerClass (FlxPoint) ;
			
			// Set to sane defaults
			clear() ;
		}
		
		/**
		 * Simple clearing method.  This just sets everything back to sane defaults.  It's import you have this, as 
		 * if there are any gaps in our incoming data stream, you will end up with null'd values.
		 * 
		 * Just set everything back to your defaults for a new game.  This function can be called by hand to force
		 * a new game.  Just clear(), then use GameStorage::saveGameData().
		 */
		override public function clear():void
		{
			trackedEnemies = new TrackedList ;
			addTrackerList (trackedEnemies) ;
			
			// Player always starts with eight bullets
			bullets = 8 ;
			
			// Set player's start position to a sane default
			playerPos = new FlxPoint (200, 200) ;
		}
		
	}

}