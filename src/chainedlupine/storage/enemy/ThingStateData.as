package chainedlupine.storage.enemy 
{
	import collab.storage.GenericData ;
	
	/**
	 * Another test storage class.
	 * 
	 * @author David Grace
	 */
	public class ThingStateData  extends GenericData
	{
		public var text:String ;
		
		public function ThingStateData() 
		{
			text = "Yay, a thing!" ;
		}
		
	}

}