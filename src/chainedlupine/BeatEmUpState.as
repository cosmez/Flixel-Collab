package chainedlupine
{
	import org.flixel.* ;
	
	// Collab stuff
	import collab.storage.GameStorage ;
	import collab.IUnloadable ;
	
	// Local game stuff
	import chainedlupine.enemy.SimpleEnemy ;
	import chainedlupine.Thing ;
	import chainedlupine.storage.BeatEmUpData ;
	import chainedlupine.storage.enemy.EnemyStateData ;
	import chainedlupine.storage.enemy.ThingStateData ;
	
	
	/**
	 * ...
	 * @author David Grace
	 */
	public class BeatEmUpState extends FlxState implements IUnloadable
	{
		public var storage:GameStorage ;
		
		// All of the game state that we want to save is to be put in here.
		public var gameData:BeatEmUpData ;
		
		// A place to put our enemies
		public var enemyGroup:FlxGroup = new FlxGroup ;
		
		override public function create():void
		{
			// Make our enemies visible
			add (enemyGroup) ;
			
			storage = FlixelCollab.getStorage() ;
			
			storage.setFolder ("BeatEmUp") ;
			
			// Tells the storage system about this class and its use as data storage medium
			storage.registerGameData (BeatEmUpData) ;

			// Create a new data storage class (auto-filled with sane defaults)
			gameData = new BeatEmUpData ;
			
			// Go ahead and write our defaults to the save
			storage.writeGameData(gameData) ;
			
			// clear our game data to prove that we're reloading it
			gameData.destroy() ;
			gameData = null ;
			
			// Read our game data back in (requiring version 1.0)
			gameData = storage.readGameData(BeatEmUpData, "1.0") ;
			
			// Output some values we saved during the creation of the game data
			FlxG.log ("ver=" + gameData.version + " gameData.atest=" + gameData.atest) ;
			FlxG.log ("testXML=" + gameData.testXML.toXMLString()) ;
			
			/* 
			 * Okay, so that's neat and all.  "Yawn.  I don't see why this is different from writing Objects directly
			 * to FlxSave.  What's so great about this method, except I have to type a bunch of annoying class crap
			 * instead of just doing 'data[mything]=5'."
			 * 
			 * First of all, this method is adaptive.  The constructor is always called on the GameData class
			 * before values are loaded into it from the SharedObject.  As long as you put sensible defaults in the
			 * ctor, then you can never end up with a corrupt game state in case you later change it.  (Say, add more
			 * properties at a later time.)  This is very different from using Objects, where you have to be
			 * careful you aren't trying to reference null values if they do not exist at the time the Object was
			 * written via FlxSave.
			 * 
			 * But that's just the surface of why you might use a GameData system.
			 * 
			 * Let's say you got a level filled with bad guys that you want to save.  The bad guys all have stateful
			 * data, such as their X/Y pixel locations, what their state machines consist of, public variables that they
			 * use to track their behavior, blah blah.
			 * 
			 * One way to track this is the Object method mentioned above.  But Objects are nasty in that they do not
			 * have compile time type checking, so it's easy to typo something and then tear your hair out when something
			 * doesn't load right.  (Speaking from experience.)
			 * 
			 * So let's create an enemy data storage class called EnemyStateData and then create some SimpleEnemies (which
			 * are just extended FlxObjects) which utilize that enemy storage to keep their stateful information.
			 */
			
			/* 
			 * Okay, time to create the SimpleEnemies.  We'll track the x,y location and the name (see
			 * EnemyStateData).
			 * 
			 * These objects implement the ITracked interface in order to properly attach themselves to a GameData
			 * reference.
			 */
			var enemyState:EnemyStateData = new EnemyStateData ;
			enemyState.loadInitialValues( { x: 15, y: 15, enemyName: "Bob" } ) ;
			var enemy:SimpleEnemy = new SimpleEnemy (enemyState) ;
			
			enemyState = new EnemyStateData ;
			enemyState.loadInitialValues ( { x: 50, y: 50, enemyName: "Flan" } ) ;
			enemy = new SimpleEnemy (enemyState) ;
			
			// Let's create another type of object to track, just to demonstrate how you can track different kinds of stuff
			var thingState:ThingStateData = new ThingStateData ;
			thingState.loadInitialValues ( { text: "Woo, another thing!" } ) ;
			var thing:Thing = new Thing (thingState) ;			
			 
			/*
			 * Ask our GameData to save all objects that have been tracked by it, this includes all SimpleEnemies/Things
			 * and SimpleEnemies.
			 */			
			gameData.saveTracked() ;
			
			// Now save this GameData again to the SharedObject
			storage.writeGameData (gameData) ;
			
			// Just some sanity checks on our enemyGroup
			FlxG.log ("living=" + enemyGroup.countLiving() + " onscreen=" + enemyGroup.countOnScreen() + " dead=" + enemyGroup.countDead()) ;

			// Then kill all of our objects so they're gone from the enemyGroup
			enemyGroup.killMembers () ;
			
			// Clear everything again
			gameData.destroy() ;
			gameData = null ;
			
			// Read the GameData back in
			gameData = storage.readGameData(BeatEmUpData) ;
			
			/* 
			 * Now comes the magical part.  Calling restoreTracked will re-institiate all of the objects that we
			 * added to our tracking list, and reload the EnemyStateData back into them upon creation.  Tada!
			 * 
			 * All of our Things and SimpleEnemies are back alive and in the enemyGroup.
			 */
			gameData.restoreTracked() ;
			
			// Just some sanity checks on our enemyGroup
			FlxG.log ("living=" + enemyGroup.countLiving() + " onscreen=" + enemyGroup.countOnScreen() + " dead=" + enemyGroup.countDead()) ;
			
			/*
			 * Okay, now that is all over with, here are some simple tests on the raw data storage methods, in case
			 * you want to treat the storage system like FlxSave.
			 */
			
			// Test the raw data storage classes			
			storage.writeData ("test", 5) ;
			FlxG.log ("test=" + storage.readData ("test")) ;
			
			storage.writeDataFolder (null, "anothertestB", true) ;
			
			if (storage.existsInFolder (null, "anothertestB"))
				FlxG.log ("anothertestB=" + storage.readDataFolder (null, "anothertestB")) ;
			
		}
		
		
		public function unload():void
		{
			storage = null ;
		}
		
	}

}