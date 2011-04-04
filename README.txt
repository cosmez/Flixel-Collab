=== Flixel Collab Readme 0.1 ===
Thanks for your interest in Flixel Collab!



=== How to Use ===
1) Create a folder inside of the "src" folder, giving it whatever name you want. This is where everything related to your game will go (your art/sound assets, your code, and so on).
2) Make your game as normal inside of your package, or just copy over the files from the "example" and change their package declarations to match your package name. Make sure to override the destroy() function for any FlxStates you have to make sure all your stuff is set to null when it is destroyed.
3) Register your game with the Game Select state by opening up GameSelectState.as, importing your FlxState, and adding it to the games list (which is done near the top of the create() function).
4) Compile and run your game! :D

OPTIONAL: If you'd like to skip the game select screen and start directly with your game, set the value of "startingState" (near the top of FlixelCollab.as) to your game's starting FlxState.



=== Flixel Collab Changelist ====
v 0.1
- FlxTilemaps now have decent pathfinding! Woo!
  The findPath() function returns a list of points from the start to end point (not including the start point). findPath() also takes in a couple extra params to give you more control over the path that is returned. Pass in "true" for the last param of loadMap() to set up the FlxPathfinding for a tilemap (though if you call findPath() later it will also set itself up at that time).

- Provided a nice wrapper for making "folders" of FlxSaves.
  Use FlixelCollab.getStorage() to get the collab.storage.GameStorage instance, and save to/load from it! (or if you like just working with FlxSave directly, you can do that too!)

- FlxFade and FlxFlash now extend a new class: FlxTransition.
  You can replace FlxG.fade or FlxG.flash with your own FlxTransitions! (Look at collab.WipeIn/Out for examples of this).

- added FlxMath, courtesy of photonstorm.
  A normalize() function has been added as well.

- added FlxBackdrop.

- added loadEmbeddedXML() and loadExternalXML() functions to FlxU.

- added photonstorm's FlxBitmapFont and cai's FlxBitmapText & FlxCaiBitmapFont.

- added disposeBitmapFromCache() function to FlxG.



=== Coming soon... ===
- .mod playback and sfxr support! (playSfxr() and playMod())
- A better example game and game select menu!
- A better readme!