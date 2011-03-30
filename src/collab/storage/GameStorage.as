package collab.storage
{
	import mx.utils.ObjectUtil ;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
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
	 * You can also store what is called GameData objects.  These are complete classes which can hold an entire
	 * game's worth of state information, including objects that can be saved to disk along with the rest!
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
		 * Registers a new GameData class with this storage system.
		 * 
		 * Required so that it will become an ISerializable.
		 */
		public function registerGameData (gameData:*):void
		{
			registerClassAlias (FlxU.getClassName (gameData), gameData) ;
		}
		
		/**
		 * This saves a GameData class into our storage system.
		 */
		public function writeGameData(gameData:*):Boolean
		{
			if (_save)
			{
				var buffer:ByteArray = new ByteArray ;
				buffer.writeObject (gameData) ;
				// No point in compressing for local storage, as AMF3 format is already zlib compressed
				//buffer.compress () ;
				buffer.position = 0 ;
				return (writeData (FlxU.getClassName (gameData), buffer)) ;
			} else
				return false ;
		}
		
		/**
		 * Reads back a GameData class.  Note that you can enforce a particular version by passing in one.  However,
		 * it isn't strictly necessary as the ctor runs for the GameData class before it is loaded, so it should already
		 * contain sane values.  But it might be necessary to ignore a GameData of an older version in case there has
		 * been a re-interpretation of the data that it stores.  Either way, your call.
		 */
		public function readGameData(gameDataClass:*, versionRequired:String = "1.0"):*
		{
			if (_save)
			{
				var classReference:* = FlxU.getClass (FlxU.getClassName (gameDataClass)) ;
				
				var buffer:ByteArray = ByteArray (readData (FlxU.getClassName (gameDataClass))) ;
				if (buffer)
				{
					// No point in compressing for local storage, as AMF3 format is already zlib compressed
					//buffer.uncompress() ;
					var gameData:* = classReference (buffer.readObject()) ;
					// Check our version number to make sure they match
					if ((gameData as GameData).version == versionRequired)
						return gameData ;  // Yippe!  Pass it back...
					else
					{
						FlxG.log ("GameStorage::readGameData version mismatch!  Expected " + versionRequired + ", received " + (gameData as GameData).version) ;
						return new classReference ;  // ...otherwise return a newly instantiated version
					}
				} else
					return new classReference ;  // We've never saved this data, so return a new instance
			} else
				return null ;
		}
		
		/**
		 * Real simple, just check to see if we've saved a copy of this game data.
		 */
		public function gameDataExists (gameDataClass:*, versionRequired:String = "1.0"):Boolean
		{
			if (_save)
			{
				return (exists (FlxU.getClassName (gameDataClass))) ;
			} else
				return false ;
			
		}
		
		/**
		 * Erases this particular gameDataClass from the save data.
		 */
		public function clearGameData (gameDataClass:*):void
		{
			if (_save)
			{
				if (exists (FlxU.getClassName (gameDataClass)))
					writeData (FlxU.getClassName (gameDataClass), null) ;
			}
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
		
		/**
		 * Helper function that simply adds an object of any type to a TrackedList.  Static so this can be called
		 * anywhere.  (Such as inside the object itself.)
		 */
		static public function addToTrackedList (list:TrackedList, what:*, dataClass:*):void
		{
			if (!dataClass is GenericData)
			{
				throw new Error ("GameStorage::addToTrackedList: We can only add GenericData descendants to the tracking list!") ;
				return ;
			}
			list.addItem (FlxU.getClassName (what), dataClass, (dataClass as GenericData).uuid) ;
		}

		/**
		 * Helper function that removes an object from a TrackedList.  Static so that this can be called anywhere.
		 */
		static public function removeFromTrackedList (list:TrackedList, what:GenericData):void
		{
			list.removeItem (what.uuid) ;
		}
		
		/**
		 * Helper function that just builds a dot-delimited path for accessing FlxSave properties.
		 */
		protected function getPath(folderName:String, dataName:String):String
		{
			if (folderName)
				return (folderName + "." + dataName) ;
			else
				return (dataName) ;
		}
		
	}

}