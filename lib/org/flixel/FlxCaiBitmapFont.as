package org.flixel
{
	import org.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * This is a text display class which uses bitmap fonts.
	 */
	public class FlxCaiBitmapFont
	{
		[Embed(source = "data/font.png")] private var imgDefaultFont:Class;
		
		/**
		 * The bounding boxes of each character
		 */
		public var rects:Array;
		/**
		 * The amount of space between characters in pixels
		 */
		public var horizontalPadding:int;
		/**
		 * The amount of space between lines in pixels
		 */
		public var verticalPadding:int;
		/**
		 * The bitmap onto which the font is loaded
		 */
		public var pixels:BitmapData;
		/**
		 * The height of the font in pixels
		 */
		public var height:uint;
		/**
		 * The alphabet represented by this font.
		 */
		private var _alphabet:String;

		
		/**
		 * Sets the font face to use.
		 * 
		 * @param	Image				The font image to use
		 * @param	Width				The width of each character if this is a fixed-width font (use 0 if it's not)
		 * @param	Height				The height of the font in pixels
		 * @param	HorizontalPadding	Padding between characters in pixels
		 * @param	VerticalPadding		Padding between lines in pixels
		 * @param	Alphabet			The alphabet represented by this font
		 */
		public function FlxCaiBitmapFont(Image:Class=null, Width:uint=0, Height:uint=5, HorizontalPadding:int=1, VerticalPadding:int=5, Alphabet:String=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
		{
			if (Image == null)
				Image = imgDefaultFont;
			pixels = FlxG.addBitmap(Image);
			height = Height;
			verticalPadding = VerticalPadding;
			horizontalPadding = HorizontalPadding;
			_alphabet = Alphabet;
			rects = new Array(); // Clear the rectangles array
			var _delimiter:uint = pixels.getPixel(0, 0); // The pixel which marks the end of a character
			var yOffset:uint;
			if (Width == 0)
				yOffset = 1; // Skip the first line since it just marks the delimiters
			else
				yOffset = 0; // There is no delimiter on fixed-width fonts
			var xOffset:uint = 0;
			var currentChar:Number = 0;
			var x:uint;
			var y:uint;
				if (Width == 0)
				{ // We need to find the end of each character
					for (y = 0; y < int(pixels.height / height); y++)
					{ // Each line in the font bitmap
						for (x = 0; x < pixels.width; x++)
						{ // Each pixel in on the X axis
						if (pixels.getPixel(x, yOffset - 1) == _delimiter)
							{ // Is this the end of a character?
								rects[_alphabet.charCodeAt(currentChar - 1)] = new Rectangle(xOffset, yOffset, x - xOffset, height); // The bounding box of the character
								currentChar++;
								xOffset = x + 1; // Set the offset to the start of the next character
							}
							if (currentChar > _alphabet.length) // There are no more characters
								return; // So don't waste time trying to add them
						}
						yOffset += height + 1;
						xOffset = 0;
					}
				}
				else
				{ // This is a fixed-width font, so we know where the end of each character is
					for (y = 0; y < int(pixels.height / height); y++)
					{ // Each line in the font bitmap
						for (x = 0; x < (pixels.width / Width); x++)
						{ // Each character on this line
							rects[_alphabet.charCodeAt(currentChar - 1)] = new Rectangle(xOffset, yOffset, Width, height); // The bounding box of the character
							xOffset = x * Width;
							currentChar++;
							if (currentChar > _alphabet.length) // There are no more characters
								return; // So don't waste time trying to add them
						}
						yOffset += height;
						xOffset = 0;
					}
				}
		}

	}
}