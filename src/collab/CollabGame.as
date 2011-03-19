package collab
{
	public class CollabGame
	{
		public var name:String;
		public var author:String;
		public var description:String;
		public var gameClass:Class;
		public var previewImages:Vector.<Class>;
		
		
		
		public function CollabGame(GameClass:Class, Name:String = "NO TITLE", Author:String = "NOBODY", Description:String = "THERE IS NO DESCRIPTION.") 
		{
			gameClass = GameClass;
			name = Name;
			author = Author;
			description = Description;
		}
	}
}