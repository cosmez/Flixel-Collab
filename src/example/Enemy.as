package example 
{
	import org.flixel.* ;
	
	import example.storage.enemy.EnemyStateData ;
	
	import collab.storage.ITracked;
	import collab.storage.GameStorage ;
	
	import mx.utils.ObjectUtil ;
	
	/**
	 * A simple enemy class.
	 * 
	 * @author David Grace
	 */
	public class Enemy extends FlxSprite implements ITracked
	{
		protected var _data:EnemyStateData ;
		protected var _state:PlatformerPlayState ;
		
		public function Enemy(incomingData:EnemyStateData) 
		{
			// We should copy this state data, so we're not changing something stored elsewhere
			_data = EnemyStateData (ObjectUtil.copy (incomingData)) ;
			
			// Keep track of our current state (for adding/removing from FlxGroups)
			_state = (FlxG.state as PlatformerPlayState) ;
						
			FlxG.log ("Created Enemy with UUID " + _data.uuid + " in ctor.") ;
			
			super (_data.x, _data.y) ;
			
			loadGraphic (Resources.GFX_ENEMY) ;
			
			_state.getEnemyGroup().add (this) ;
			
			acceleration.y = 150 ;
			
			// Go ahead and add this to our GameData's enemy track list
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
			_data = null ;
		}
		
		// Interface for ITracked
		public function addToTrackedList():void
		{
			// The array at the end contains our tracked data classes
			GameStorage.addToTrackedList (_state.gameData.trackedEnemies, this, _data) ;
		}
		
		// Interface for ITracked
		public function removeFromTrackedList():void
		{
			GameStorage.removeFromTrackedList (_state.gameData.trackedEnemies, _data) ;
		}		
		
		
	}

}