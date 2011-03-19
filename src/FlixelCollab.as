package 
{
	import org.flixel.*;
	import collab.*;

	// Make the SWF display with a width of 640x480.
	
	//[SWF(width = "600", height = "600", backgroundColor = "#000022")]
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	// Set Preloader class name.
    [Frame(factoryClass="Preloader")]

    public class FlixelCollab extends FlxGame
    {
        public function FlixelCollab()
        {
			// Make the game have 400x300 resolution at regular 2x pixel zoom. Start the game in PlayState.
			super(320, 240, GameSelectState, 2);
			
			// Change the pause menu to be ours, not 
			this.pause = new CollabPause();
			
			// Make the framerate while paused be not shitty.
			FlxG.frameratePaused = 60;
			
			// Disable pausing at first since we're going into GameSelectState first.
			FlxG.pausingEnabled = false;
        }
    }
}
