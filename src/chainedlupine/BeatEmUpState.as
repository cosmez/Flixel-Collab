package chainedlupine
{
	import org.flixel.* ;
	
	// Collab stuff
	import collab.storage.GameStorage ;
	
	/**
	 * ...
	 * @author David Grace
	 */
	public class BeatEmUpState extends FlxState 
	{
		public var storage:GameStorage ;
		
		public function BeatEmUpState() 
		{
			storage = FlixelCollab.getStorage() ;
			
			storage.setFolder ("BeatEmUp") ;
			
			storage.writeData ("test", 5) ;
			FlxG.log (storage.readData ("test")) ;
			
			storage.writeDataFolder (null, "anothertestB", true) ;
			
			if (storage.existsInFolder (null, "anothertestB"))
				FlxG.log (storage.readDataFolder (null, "anothertestB")) ;
		}
		
	}

}