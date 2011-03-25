package chainedlupine
{
	import flash.geom.Rectangle ;
	import mx.utils.ObjectUtil ;
	
	import chainedlupine.BeatEmUpState;
	import chainedlupine.storage.enemy.ThingStateData;
	
	import collab.storage.ITracked;
	import collab.storage.GameStorage ;
	
	
	import org.flixel.* ;
	
	/**
	 * A generic thing that extends a FlxSprite.
	 * 
	 * @author David Grace
	 */
	public class Thing extends FlxSprite implements ITracked
	{
		protected var _thingData:ThingStateData ;
		protected var _state:BeatEmUpState ;
		protected var _nameTxt:FlxText ;
		
		public function Thing(incomingState:ThingStateData) 
		{
			// We should copy this state data, so we're not changing something stored elsewhere
			_thingData = ThingStateData (ObjectUtil.copy (incomingState)) ;
			
			FlxG.log ("Thing with UUID " + _thingData.uuid + " in ctor.") ;
			
			// Do the original FlxObject ctor
			super (100, 50) ;
			
			// Create a graphic
			createGraphic (30, 30, 0xFF00FF00) ;
			
			// Keep track of our current state (for adding/removing from FlxGroups)
			_state = (FlxG.state as BeatEmUpState) ;
			
			// Add ourselves to the enemyGroup list (for rendering, etc)
			_state.enemyGroup.add (this) ;
			
			// Debug name display
			_nameTxt = new FlxText (x - 5, y - 10, 150, _thingData.text, true) ;
			_state.enemyGroup.add (_nameTxt) ;
			
			// Go ahead and add this to our GameData's thing track list
			addToTrackedList() ;			
		}

		// If we're killed in the game, then stop tracking us
		override public function kill():void
		{
			super.kill() ;
			removeFromTrackedList() ;
		}
		
		/**
		 * Cleanup after ourselves
		 */
		override public function destroy():void
		{
			super.destroy() ;
			_state = null ;
			_nameTxt = null ;
			_thingData = null ;
		}
		
		// Interface for ITracked
		public function addToTrackedList():void
		{
			// The array at the end contains our tracked data classes
			GameStorage.addToTrackedList (_state.gameData.trackedThings, this, _thingData) ;
		}
		
		// Interface for ITracked
		public function removeFromTrackedList():void
		{
			GameStorage.removeFromTrackedList (_state.gameData.trackedThings, _thingData) ;
		}		
		
	}

}