package collab.storage
{
	import mx.utils.UIDUtil ;
	
	/**
	 * This is a generic data class to be used by tracked objects.
	 * 
	 * You can subclass it to put anything you want in it.  JUST BE SURE TO REGISTER IT IN THE GAMEDATA CLASS! (See
	 * GameData::RegisterClass)
	 * 
	 * @author David Grace
	 */
	public class GenericData
	{
		/**
		 * A UUID of our data class, used to track unique instances in a TrackedList
		 */
		public var uuid:String ;
		
		
		public function GenericData ()
		{
			super () ;
			
			// Not truely unique, but should be good enough for this.
			uuid = UIDUtil.createUID () ;
		}
		
		/**
		 * Helper function that just assigns properties to this state from the initial object we are given.
		 * 
		 * You can do it by hand if you want.
		 */
		public function loadInitialValues (initialValues:Object):GenericData
		{
			for (var property:String in initialValues)
			{
				var value:* = initialValues[property] ;
				this[property] = value ;
			}
			return this ;
		}
	}

}