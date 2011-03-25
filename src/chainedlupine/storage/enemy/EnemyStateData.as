package chainedlupine.storage.enemy
{
	import collab.storage.GenericData ;
	
	import org.flixel.* ;
	
	/**
	 * A data storage class for Enemies
	 * 
	 * @author David Grace
	 */
	public class EnemyStateData extends GenericData
	{
		public var enemyName:String ;
		public var x:int ;
		public var y:int ;
		
		public function EnemyStateData() 
		{
			// Set some sane defaults
			enemyName = "nobody" ;
			x = 0 ;
			y = 0 ;			
		}
		
	}

}