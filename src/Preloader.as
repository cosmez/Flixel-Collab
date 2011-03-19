package
{
	import org.flixel.FlxPreloader;
	
	
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader()
		{
			trace("/// PRELOADER ///");
			
			//minDisplayTime = 2.0; // Only noticeable in release build (browser).
			
			// Set FlxGame class name.
			className = "FlixelCollab";
			
			//allowObjectCopying(); // is it possible?
			
			super();
		}
	}
}