package collab.storage
{
	import flash.net.registerClassAlias;
	import org.flixel.* ;
	
	/**
	 * Template for creating a game data storage object.
	 * 
	 * Nothing in here by default except the version string, but extend it to add your own properties.
	 * 
	 * Note that only PUBLIC properties are saved.  Private/protected/internal properties are ignored.
	 * 
	 * @author David Grace
	 */
	public class GameData 
	{
		public var version:String = "1.0" ;
		
		public var tracked:Array ;
		
		public function GameData() 
		{
			// We should always be aware of TrackedList, in case we add some to this class
			registerClass (TrackedList) ;
			
			tracked = new Array ;
		}
		
		/**
		 * Default clear method.  It's intended that you override this in your subclasses and fill it with default, sane
		 * values upon institation.  Also use it if you want to reset all GameData back to defaults.
		 */
		public function clear():void
		{
			tracked = new Array ;
			
			// Unregister our tracked lists
			for (var i:int = 0; i < tracked.length; i++)
			{
				tracked[i] = null ;
			}
		}
		
		/**
		 * Register a class with the GameData storage system.  If you use anything but the standard AS3 data types,
		 * you need to register them so that the serializer can properly pack/unpack these classes.
		 * 
		 * When you load a GameData and you get "Type Coericon failed: cannot convert Object@<hex> to MyClass", then
		 * you forgot to register it with this method. :)
		 * 
		 * @param	inClass		Custom class to register.
		 */
		public function registerClass (inClass:*):void
		{
			registerClassAlias (FlxU.getClassName (inClass), inClass) ;
		}
		
		/**
		 * Adds a TrackedList to this GameData object, so that it will be a part of the serialization/restoring.
		 */
		public function addTrackerList (list:TrackedList):void
		{
			var index:int = tracked.indexOf (list) ;
			if (!~index)
				tracked.push (list) ;
		}
		
		/**
		 * Removes a TrackerList for bookkeeping purposes.
		 */
		public function removeTrackerList (list:TrackedList):void
		{
			var index:int = tracked.indexOf (list) ;
			if (~index)
				tracked.splice (index, 1) ;
		}
		
		/**
		 * Save all of our current TrackedList items in our GameData.
		 */
		public function saveTracked():void
		{
			// So we need to loop through all the TrackedLists that we have, and serialize each data class
			for each (var trackedList:TrackedList in tracked)
			{
				trackedList.serialize() ;
			}
		}
		
		/**
		 * Re-instiatiate classes that have been saved in our GameData set of tracked objects.
		 */
		public function restoreTracked():void
		{
			// Loop through each TrackedList and recreate from saved data
			for each (var trackedList:TrackedList in tracked)
			{
				trackedList.recreate() ;
			}			
		}
		
		/**
		 * Bookkeeping.
		 */
		public function destroy():void
		{
			clear () ;
			tracked = null ;
		}
		
	}

}