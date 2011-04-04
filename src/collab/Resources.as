package collab
{
	// A simple class that holds all the graphics and sounds used by GameSelectState.
	// If you want to see how your game will show up in the GameSelectState, embed your
	// preview files in here and modify GameSelectState to use them.
	public class Resources
	{
		// The devs stuff.
		[Embed(source = "gfx/no_icon.png")] public static const GFX_NO_GAME_ICON :Class;
		[Embed(source = "gfx/no_preview.png")] public static const GFX_NO_GAME_PREVIEW :Class;
		
		[Embed(source = "../example/Game Icon.png")] public static const GFX_GAME1_ICON :Class;
		[Embed(source = "../example/Game Preview 1.png")] public static const GFX_GAME1_PREVIEW1 :Class;
		//[Embed(source = "../example/Game Preview 2.png")] public static const GFX_GAME1_PREVIEW2 :Class;
		//[Embed(source = "../example/Game Preview 3.png")] public static const GFX_GAME1_PREVIEW3 :Class;
		//[Embed(source = "../example/Game Preview 4.png")] public static const GFX_GAME1_PREVIEW4 :Class;
		//[Embed(source = "../example/Game Preview 5.png")] public static const GFX_GAME1_PREVIEW5 :Class;
		
		//[Embed(source = "../game2/Game Icon.png")] public static const GFX_GAME2_ICON :Class;
		//[Embed(source = "../game2/Game Preview 1.png")] public static const GFX_GAME2_PREVIEW1 :Class;
		
		//[Embed(source = "../game3/Game Icon.png")] public static const GFX_GAME3_ICON :Class;
		//[Embed(source = "../game3/Game Preview 1.png")] public static const GFX_GAME3_PREVIEW1 :Class;
		
		//[Embed(source = "../game4/Game Icon.png")] public static const GFX_GAME4_ICON :Class;
		//[Embed(source = "../game4/Game Preview 1.png")] public static const GFX_GAME4_PREVIEW1 :Class;
		
		//[Embed(source = "../game5/Game Icon.png")] public static const GFX_GAME5_ICON :Class;
		//[Embed(source = "../game5/Game Preview 1.png")] public static const GFX_GAME5_PREVIEW1 :Class;
		
		//[Embed(source = "../game6/Game Icon.png")] public static const GFX_GAME6_ICON :Class;
		//[Embed(source = "../game6/Game Preview 1.png")] public static const GFX_GAME6_PREVIEW1 :Class;
		
		//[Embed(source = '../chainedlupine/Game Icon.png')]	public static const GFX_GAME3_ICON: Class ;
		//[Embed(source = '../chainedlupine/Game Preview.png')]	public static const GFX_GAME3_PREVIEW1:Class ;
		
		[Embed(source = "fonts/deltaforce_blue_outline_font.png")] public static const GFX_TITLE_FONT :Class;
		
		
		
		// Everything else.
		[Embed(source = "bgm/banja_dsx_trsi.mod", mimeType = "application/octet-stream")] public static const BGM_SONG :Class;
		
		[Embed(source = "sfx/confirm.mp3")] public static const SFX_CONFIRM :Class;
		[Embed(source = "sfx/cancel.mp3")] public static const SFX_CANCEL :Class;
		[Embed(source = "sfx/move_cursor.mp3")] public static const SFX_MOVE_CURSOR :Class;
		[Embed(source = "sfx/open_pause.mp3")] public static const SFX_OPEN_PAUSE :Class;
		
		[Embed(source = "gfx/game_select_backdrop.png")] public static const GFX_GAME_SELECT_BACKDROP :Class;
		[Embed(source = "gfx/game_info_box.png")] public static const GFX_GAME_INFO_BOX :Class;
		[Embed(source = "gfx/game_selector.png")] public static const GFX_GAME_SELECTOR :Class;
		[Embed(source = "gfx/pause.png")] public static const GFX_PAUSE_BACKDROP :Class;
		
		[Embed(source="../../lib/org/flixel/data/key_minus.png")] public static const ImgKeyMinus:Class;
		[Embed(source="../../lib/org/flixel/data/key_plus.png")] public static const ImgKeyPlus:Class;
		[Embed(source="../../lib/org/flixel/data/key_0.png")] public static const ImgKey0:Class;
		[Embed(source="../../lib/org/flixel/data/key_p.png")] public static const ImgKeyP:Class;
	}
}