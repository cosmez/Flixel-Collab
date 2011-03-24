package example
{
	public class Resources
	{
		[Embed(source = "assets/gfx/cowboy.png")] public static const GFX_COWBOY :Class;
		[Embed(source = "assets/maps/map_tiles.png")] public static const GFX_TEST_TILES :Class;
		
		[Embed(source = "assets/bgm/banja_dsx_trsi.mod", mimeType = "application/octet-stream")] public static const BGM_SONG :Class;
		
		[Embed(source = "assets/maps/testMap.txt", mimeType = "application/octet-stream")] public static const MAP_TEST_MAP :Class;
	}
}