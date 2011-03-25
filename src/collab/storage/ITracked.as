package collab.storage
{
	
	/**
	 * Any object that wants to be tracked by a GameData class needs to implement this interface.
	 * 
	 * @author David Grace
	 */
	public interface ITracked
	{
		/**
		 * Override to add this object to the appropriate tracking list.  Calling this function multiple times is
		 * harmless.
		 */
		function addToTrackedList():void
		
		/**
		 * Override to remove this object from the appropriate tracking list.  Useful when you want to stop tracking
		 * this object and not have it revive.  (Say, when it dies/goes out of scope.)
		 */
		function removeFromTrackedList():void
	}
	
}