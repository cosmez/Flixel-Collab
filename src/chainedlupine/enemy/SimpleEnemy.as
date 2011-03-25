package chainedlupine.enemy
{
	import flash.geom.Rectangle ;
	import mx.utils.ObjectUtil ;
	
	import chainedlupine.BeatEmUpState;
	import chainedlupine.storage.enemy.EnemyStateData;
	
	import collab.storage.ITracked;
	import collab.storage.GameStorage ;
	
	import org.flixel.* ;
	
	/**
	 * A base enemy type that automatically gets tracked by our GameData.
	 * 
	 * @author David Grace
	 */
	public class SimpleEnemy extends FlxObject implements ITracked
	{
		// Reference to our parent state, for bookkeeping
		protected var _state:BeatEmUpState ;
		
		protected var _nameTxt:FlxText ;
		
		/* Here's the meat of the system.  Put anything you want to be saved to the GameData stream inside of this
		 * data class.
		 * 
		 * Note: Nothing else in this class is saved into the GameData stream.  So feel free to go nuts with
		 * publics/statics/etc.
		 */
		protected var _trackedData:EnemyStateData ;

		/**
		 * Your constructor must accept nothing but the serialized data class that will then re-create your entire
		 * object from the serialized data.
		 * 
		 * @param	enemyState		Our data storage class that holds our complete state information.
		 */
		public function SimpleEnemy(incomingState:EnemyStateData) 
		{
			// We should copy this state data, so we're not changing something stored elsewhere
			_trackedData = EnemyStateData (ObjectUtil.copy (incomingState)) ;
			
			FlxG.log ("SimpleEnemy with UUID " + _trackedData.uuid + " in ctor.") ;
			
			// Do the original FlxObject ctor
			super (_trackedData.x, _trackedData.y, 10, 10) ;
			
			// Keep track of our current state (for adding/removing from FlxGroups)
			_state = (FlxG.state as BeatEmUpState) ;
			
			// Add ourselves to the enemyGroup list (for rendering, etc)
			_state.enemyGroup.add (this) ;
			
			// Debug name display
			_nameTxt = new FlxText (x - 5, y - 10, 150, _trackedData.enemyName, true) ;
			_state.enemyGroup.add (_nameTxt) ;
			
			// Go ahead and add this to our GameData's enemy track list
			addToTrackedList() ;
		}
		
		// Getter/setter for our tracked value
		public function get name():String				{ return _trackedData.enemyName }		
		public function set name(v:String):void			{ _trackedData.enemyName = v ; _nameTxt.text = v }
		
		// Just a tester render function
		override public function render():void
		{
			super.render() ;
			var screenPoint:FlxPoint = getScreenXY() ;
			FlxG.buffer.fillRect (new Rectangle (screenPoint.x, screenPoint.y, width, height), 0xFFFF0000) ;			
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
			_trackedData = null ;
		}
		
		// Interface for ITracked
		public function addToTrackedList():void
		{
			// The array at the end contains our tracked data classes
			GameStorage.addToTrackedList (_state.gameData.trackedEnemies, this, _trackedData) ;
		}
		
		// Interface for ITracked
		public function removeFromTrackedList():void
		{
			GameStorage.removeFromTrackedList (_state.gameData.trackedEnemies, _trackedData) ;
		}		
	}

}