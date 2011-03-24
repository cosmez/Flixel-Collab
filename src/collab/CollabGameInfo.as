package collab
{
	public class CollabGameInfo
	{
		public var name:String;
		public var author:String;
		public var description:String;
		public var gameClass:Class;
		public var iconImage:Class;
		public var previewImages:Vector.<Class>;
		
		
		
		public function CollabGameInfo(GameClass:Class, IconGraphic:Class = null, Name:String = "NO TITLE", Author:String = "NOBODY", Description:String = "THERE IS NO DESCRIPTION.") 
		{
			gameClass = GameClass;
			iconImage = IconGraphic;
			name = Name;
			author = Author;
			description = Description;
			previewImages = new Vector.<Class>();
		}
	}
}