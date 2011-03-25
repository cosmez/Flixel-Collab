package chainedlupine.storage
{
	import collab.storage.GameData ;
	import collab.storage.TrackedList ;
	
	import chainedlupine.storage.enemy.EnemyStateData ;
	import chainedlupine.storage.enemy.ThingStateData ;
	
	import org.flixel.* ;
	
	
	/**
	 * ...
	 * @author David Grace
	 */
	public class BeatEmUpData extends GameData 
	{
		public var atest:String ;
		
		// A list of all enemies that are tracked
		public var trackedEnemies:TrackedList ;
		
		// Another list of things to track
		public var trackedThings:TrackedList ;
		
		// Yes, you can store XML
		public var testXML:XML ;
		
		public function BeatEmUpData() 
		{
			// Call super, otherwise import stuff doesn't get registered!
			super() ;
			
			// Be sure to register any classes that might get tracked in this GameData OR in any of its tracked objects!			
			registerClass (EnemyStateData) ;
			registerClass (ThingStateData) ;
			
			// Set to sane defaults
			clear() ;
		}
		
		/**
		 * Simple clearing method.  This just sets everything back to sane defaults.  It's import you have this, as 
		 * if there are any gaps in our incoming data stream, you will end up with null'd values.
		 */
		override public function clear():void
		{
			// Create a new tracking list for our enemies
			trackedEnemies = new TrackedList ;
			addTrackerList (trackedEnemies) ;
			
			// And another tracking list for our things
			trackedThings = new TrackedList ;
			addTrackerList (trackedThings) ;
			
			// Just write some garbage out to these properties to test things
			atest = "Yay!" ;
			
			// XML is being stored in us.  Ut-oh!
			testXML = 
				<blargh stuff="blub">
					<!-- Comments are stripped out, BTW. :) -->
					Text, in *MY* XML?
				</blargh> ;
			
		}
		
	}

}