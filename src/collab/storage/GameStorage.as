package collab.storage
{
	import org.flixel.*;
	
	/**
	 * Global storage system.  This is the central storage for all game saves/etc that might need to be written
	 * to a SharedObject.  Why use this over FlxSave?  Well, it has a lot of convenience functions and it keeps
	 * everything consistent.
	 * 
	 * You can subdivide into various sub-sections, too, using folders.
	 * 
	 * Only cavaet?  Don't use peroids in your data field names otherwise you break the folder system.
	 * 
	 * Folders are used by the Flixel Collab game system to keep track of states for each seperate game.  All
	 * public Flixel Collab settings are stored in the folder named "Collab".
	 * 
	 * @author David Grace
	 */
	public class GameStorage 
	{
		private var _save:FlxSave ;
		
		private var _currentFolderName:String ;
		
		/**
		 * Starts up the GameStorage system.  Pretty much all it does is create a handle to a FlxSave.
		 * 
		 * @param	storageName		The name of the SharedObject to create.
		 */
		public function GameStorage(storageName:String) 
		{
			_save = new FlxSave () ;
			
			_currentFolderName = null ; // Null folder means root
			
			if (_save.bind (storageName))
			{
				// We have a working SharedObject, so we're good.
			} else
			{
				throw new Error ("Unable to bind to SharedObject named " + storageName +"!") ;
				_save = null ;
			}
		}
		
		/**
		 * Sets the current folder to be the active read/write folder.
		 * 
		 * @param	folderName		Folder to set active.
		 */
		public function setFolder (folderName:String):void
		{
			_currentFolderName = folderName ;
		}
		
		/**
		 * This writes a raw data value to the current stream.
		 * 
		 * @param	dataName	Name of the data to write.
		 * @param	value		Value to actually write.
		 */
		public function writeData (dataName:String, value:*):Boolean
		{
			return writeDataFolder (_currentFolderName, dataName, value) ;
		}
		
		/**
		 * Reads data from the current folder.
		 * 
		 * @param	dataName	The data name to read.
		 *
		 * @return	The data read, or null if no worky
		 */
		public function readData (dataName:String):*
		{
			return readDataFolder (_currentFolderName, dataName) ;
		}
		
		/**
		 * Check to see if a data name exists in the current folder.
		 */
		public function exists (dataName:String):Boolean
		{
			return (existsInFolder (_currentFolderName, dataName)) ;
		}

		/**
		 * Deeper, internal-ish function that reads data from a specific folder in the save.
		 */
		public function readDataFolder (folderName:String, dataName:String):*
		{
			if (_save)
			{
				return (_save.read (getPath (folderName, dataName))) ;
			}
			else
				return null ;
		}
		
		/**
		 * Writes data to a particular folder inside the save.  Kinda internal-ish, but go ahead and use it if you
		 * know what folder you want to work with.  This is quicker than creating a save object or setFolder.
		 */
		public function writeDataFolder (folderName:String, dataName:String, value:*):Boolean
		{
			if (_save)
			{
				return (_save.write (getPath (folderName, dataName), value)) ;
			}
			else
				return false ;
		}
		
		/**
		 * Internal-ish function that checks to see if a property on the save exists.
		 */
		public function existsInFolder (folderName:String, dataName:String):Boolean
		{
			if (_save)
			{
				return (_save.data.hasOwnProperty (getPath (folderName, dataName))) ;
			} else
				return false ;
		}
		
		protected function getPath(folderName:String, dataName:String):String
		{
			if (folderName)
				return (folderName + "." + dataName) ;
			else
				return (dataName) ;
		}
		
	}

}