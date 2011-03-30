package collab.storage
{
	import flash.utils.ByteArray;
	import org.flixel.* ;
	
	/**
	 * A TrackedList is an internal representation of objects that we're tracking the state of.  Several things are
	 * stored in a tracked list:
	 * 
	 * - The class type of the institiate class.  This is a FQN of the class, so we can re-create it later.
	 * - The data class type of the data class.  Same as above, save it it's for the data class.
	 * - A data class reference, which holds a pointer to the current instiitiated data class.
	 * - UUID of this object.  Should be unique.
	 * - The stored data that is written into a ByteArray after the data class is serialized.
	 * 
	 * @author David Grace
	 */
	public class TrackedList
	{
		public var list:Array ;
		
		public function TrackedList() 
		{
			super() ;
			list = new Array ;
		}
		
		/**
		 * Adds an object (and its associated data class) to this tracked list.
		 */
		public function addItem (ClassType:String, DataClass:*, UUID:String):void
		{
			// Look for our uuid to varify we are unique
			for (var i:int = 0; i < list.length; i++)
			{
				var data:Object ;
				if (list[i])
				{
					data = list[i] ;
					if (data.uuid == UUID)
					{
						// Already in here, so no need to re-add
						return ;
					}
				}
			}
			list.push ( { 
					instantiatedClassType: ClassType, dataClassType: FlxU.getClassName (DataClass),
					dataClassRef: DataClass, uuid: UUID, storedData: null 
				} ) ;
		}
		
		/**
		 * Removes an object (via UUID) from this tracked list.
		 */
		public function removeItem (UUID:String):void
		{
			// Look for our uuid
			for (var i:int = 0; i < list.length; i++)
			{
				var data:Object ;
				if (list[i])
				{
					data = list[i] ;
					if (data.uuid == UUID)
					{
						list[i] = null ;
						return ;
					}
				}
			}
		}
		
		/**
		 * Begin serialization of all data classes.  Basically this just fills out the storedData.
		 */
		public function serialize():void
		{
			var cnt:int = 0 ;
			for (var i:int = 0; i < list.length; i++)
			{
				var data:Object ;
				if (list[i])
				{
					data = list[i] ;
					
					var bytes:ByteArray = new ByteArray ;
					bytes.writeObject (data.dataClassRef) ;
					
					data.storedData = bytes ;
					cnt++ ;
				}
			}
			FlxG.log ("TrackedList::serialize: " + this + " serialized " + cnt + " objects.") ;
		}
		
		/**
		 * Re-creates our institiated classes and feeds them a new reloaded & re-institiated data class.  The object
		 * should take care of everything from there.
		 */
		public function recreate():void
		{
			var cnt:int = 0 ;
			for (var i:int = 0; i < list.length; i++)
			{
				var data:Object ;
				if (list[i])
				{
					data = list[i] ;
					
					/*
					 * So our serialize data is stored in storedData, our institiated class type in instantiatedClassType, and
					 * dataClassType is the class type of our data class.
					 * 
					 * We can safely ignore dataClassRef, because this is just a stale pointer to the original in-
					 * memory representation of our storedData.
					 */

					// Reload stored data back into a dataClass
					var bytes:ByteArray = data.storedData ;
					// Reset pointer (in case this has been done before)
					bytes.position = 0 ;
					
					var dataClassType:* = FlxU.getClass (data.dataClassType) ;
					var dataClass:* = dataClassType (bytes.readObject()) ;
					 
				 
					// Update dataClassRef to point to this new data class
					data.dataClassRef = dataClass ;
					 
					// Now, re-institiate our original class
					var originalClassType:* = FlxU.getClass (data.instantiatedClassType) ;
					var originalClass:* = new originalClassType (dataClass) ;
					 
					cnt++ ;					
				}
			}			
			FlxG.log ("TrackedList::recreate: " + this + " recreated " + cnt + " objects.") ;
			
		}
		
		/**
		 * Debug FTW.
		 */
		public function toString():String
		{
			return FlxU.getClassName (this) ;
		}
		
		public function get length():int
		{
			return (list.length) ;
		}
		
	}

}