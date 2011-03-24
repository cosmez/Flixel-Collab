package org.flixel
{
	import org.flixel.* ;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	/**
	 * This is a text display class which uses bitmap fonts.
	 */
	public class FlxBitmapText extends FlxObject
	{
		/**
		 * The bitmap onto which the text is rendered
		 */
		protected var _pixels:BitmapData;
		/**
		 * The coordinates to which several things are copied
		 */
		protected var _p:Point;
		/**
		 * The bounding box of the internal bitmap
		 */
		protected var _frect:Rectangle;
		/**
		 * This is used to change the color of the bitmap
		 */
		protected var _cTransform:ColorTransform = new ColorTransform;
		/**
		 * The bitmap font to use
		 */
		protected var _font:FlxCaiBitmapFont;
		/**
		 * The text to render
		 */
		protected var _text:String;
		/**
		 * The text alignment
		 */
		protected var _alignment:String;
		/**
		 * The default font to use
		 */
		static protected var _defaultFont:FlxCaiBitmapFont;
		
		protected var _overrideWidth:int ;
		
		protected var _colorFont:Boolean = true; // I did this.
		
		protected var _lineWrap:Boolean ;
		
		/**
		 * Creates a new <code>FlxBitmapText</code> object.
		 * 
		 * @param	X					The X position of the text
		 * @param	Y					The Y position of the text
		 * @param	Font				The bitmap font to use - NOTE: Passing null uses the default font
		 * @param	Text				The default text to display
		 * @param	Alignment			"Left", "Center", or "Right"
		 * @param	Width				The width of the text box in pixels (0 means auto)
		 */
		public function FlxBitmapText(X:int, Y:int, Font:FlxCaiBitmapFont, Text:String=" ", Alignment:String="left", Width:Number=0)
		{
			if (Font == null) // Use the default font
				Font = _defaultFont ? _defaultFont : new FlxCaiBitmapFont; // If it doesn't exist yet, create it
			_font = Font;
			_text = Text;
			_alignment = Alignment.toLowerCase();
			super();
			fixed = true;
			x = X;
			y = Y;
			width = Width;
			_cTransform.color = 0xFFFFFF ;
			_cTransform.alphaMultiplier = 1.0 ;
			_lineWrap = true ;
			_p = new Point();
			calcFrame();
		}
		
		/**
		 * Updates the internal bitmap.
		 */
		public function calcFrame():void
		{
			height = 0;
			var i:uint;
			var c:uint;
			var _lines:Array = new Array;
			var _splitLines:Array = _text.split("\n"); // An array of each line to render
			if (_lineWrap && width > 0)
			{
				var line:String = "" ; // Current line string accumulator
				
				var si:int = 0 ; // start at beginning of _text
				var lw:int = 0 ; // line width so far (pixels)
				
				// Now, wrap lines further based on total width of FlxObject
				while (si < _text.length)
				{
					var split:Boolean = false ;
					var char:int = _text.charCodeAt(si++) ;
					
					if (char == 10) // LF, so do a split immediately
						split = true ;
					else 
						if (_font.rects[char])
						{
							lw += (overrideWidth ? overrideWidth :_font.rects[char].width) + _font.horizontalPadding ;
							if (lw > width)  // Line is too long
							{
								line += String.fromCharCode (char) ;
								split = true ;
								// Back up to the last space
								while (si >= 0 && _text.charCodeAt (si) != 32)
								{
									si-- ;
									line = line.slice (0, line.length - 1) ;  // Chop off one of our line buffer
								}
								si++ ;  // Skip forward (over space)
							}
							else
								line += String.fromCharCode (char) ;
						}
						
					if (split)
					{
						// Accumulate in lines
						_lines.push (String (line.replace (/^\s+|\s+$/g, ""))) ;  // Trim whitespace
						line = "" ;
						lw = 0 ;
					}
				}
				
				if (line.length > 0)
					_lines.push (String (line)) ; // Push the last line
			} else
				// No word wrapping
				_lines = _splitLines
			
			var _lineWidths:Array = new Array(); // An array of the widths of each line
			// We need to get the size of the bitmap, so we'll examine the text character-by-character
			for (i = 0; i < _lines.length; i++)
			{ // Loop through each line
				_lineWidths[i] = 0;
				for (c = 0; c < _lines[i].length; c++)
				{ // Each character in the line
					if (_font.rects[_lines[i].charCodeAt(c)])
					{ // Does the character exist in the font?
						_lineWidths[i] += (overrideWidth ? overrideWidth :_font.rects[_lines[i].charCodeAt(c)].width) + _font.horizontalPadding; // Add its width to the line width
						//FlxG.log (_lines[i].charAt(c) + " w=" + _font.rects[_lines[i].charCodeAt(c)].width + " total=" + _lineWidths[i]) ;
					}
				}
				_lineWidths[i] -= _font.horizontalPadding ;
				if (_lineWidths[i] > width) // Find out which line is the widest
					width = _lineWidths[i]; // Use that line as the bitmap's width
				height += _font.height + _font.verticalPadding; // Set the height to the font height times the number of lines
			}
			//width -= _font.horizontalPadding; // Don't apply horizontal padding to the last letter
			height -= _font.verticalPadding; // Don't apply vertical padding to the last line
			if ((width < 1) || (height < 1))
			{ // If there's nothing to render
				width = 1; // Set the width
				height = 1; // And the height
			}
			if (_pixels)
				_pixels.dispose() ;
			_pixels = new BitmapData(width, height, true, 0x00000000); // Create a transparent bitmap
			var xOffset:uint;
			var yOffset:uint = 0;
			// Now we can start drawing on the bitmap
			for (i = 0; i < _lines.length; i++)
			{ // Loop through each line
				switch(_alignment)
				{ // Adjust where we start drawing for alignment
					case 'left':
						xOffset = 0;
					break;
					case 'center':
						xOffset = int((width - _lineWidths[i]) / 2);
					break;
					case 'right':
						xOffset = width - _lineWidths[i];
					break;
				}
				for (c = 0; c < _lines[i].length; c++)
				{ // Each character in the line
					if (_font.rects[_lines[i].charCodeAt(c)])
					{ // Make sure the character is in the font
						_p.x = xOffset + (overrideWidth ? Math.floor ((overrideWidth - _font.rects[_lines[i].charCodeAt(c)].width) / 2) : 0);
						_p.y = yOffset;
						_pixels.copyPixels(_font.pixels, _font.rects[_lines[i].charCodeAt(c)], _p, null, null, true); // Copy it to the bitmap
						xOffset += (overrideWidth ? overrideWidth : _font.rects[_lines[i].charCodeAt(c)].width) + _font.horizontalPadding; // Add the width of the character
					}
				}
				yOffset += _font.height + _font.verticalPadding;
			}
			_frect = new Rectangle(0, 0, width, height); // The boundaries of the object
			if (!_colorFont)
				_pixels.colorTransform(_frect, _cTransform); // Change the color if need be
		}
		
		/**
		 * Draws the text to the screen.
		 */
		override public function render():void
		{
			super.render();
			getScreenXY(_point);
			_p.x = _point.x; //wat
			_p.y = _point.y;
			FlxG.buffer.copyPixels(_pixels, _frect, _p, null, null, true);
		}
		
		/**
		 * Changes the text being displayed.
		 * 
		 * @param	Text	The new string you want to display
		 */
		public function set text(Text:String):void
		{
			_text = Text;
			calcFrame(); // Update the bitmap
		}
		
		/**
		 * Getter to retrieve the text being displayed.
		 * 
		 * @return	The text string being displayed.
		 */
		public function get text():String
		{
			return _text;
		}
		
		public function set overrideWidth(v:int):void
		{
			_overrideWidth = v ;
		}
		
		public function get overrideWidth():int
		{
			return _overrideWidth ;
		}
		
		public function set lineWrap(v:Boolean):void
		{
			_lineWrap = v ;
		}
		
		public function get lineWrap():Boolean
		{
			return _lineWrap ;
		}
		
		/**
		 * Sets the alignment of the text being displayed
		 * 
		 * @param	A string indicating the desired alignment - acceptable values are "left", "right" and "center"
		 */
		public function set alignment(Alignment:String):void
		{
			_alignment = Alignment.toLowerCase(); // It's expecting the alignment to be all lowercase
			calcFrame(); // Update the bitmap
		}
		
		/**
		 * Gets the alignment of the text being displayed
		 * 
		 * @return	A string indicating the current alignment.
		 */
		public function get alignment():String
		{
			return _alignment;
		}
		
		/**
		 * Sets the color of the text
		 * 
		 * @param	Color	The color you want the text to appear (Note: it will become fully opaque!)
		 */
		public function set color(Color:uint):void
		{
			_cTransform.color = Color;
			calcFrame(); // Update the bitmap
		}
		
		public function get color():uint
		{
			return (_cTransform.color) ;
		}
		
		public function set colorFont(v:Boolean):void
		{
			_colorFont = v ;
			calcFrame() ;
		}
		
		public function get colorFont():Boolean
		{
			return _colorFont ;
		}
		
		public function set alpha(Alpha:Number):void
		{
			if(Alpha > 1) Alpha = 1;
			if(Alpha < 0) Alpha = 0;
			if(Alpha == _cTransform.alphaMultiplier) return;
			_cTransform.alphaMultiplier = Alpha ;
			calcFrame();			
		}
		
		public function get alpha():Number
		{
			return _cTransform.alphaMultiplier ;
		}
		
		/**
		 * Sets the font for the text
		 * 
		 * @param	Font	The font to use
		 */
		public function set font(Font:FlxCaiBitmapFont):void
		{
			if (Font == null) // Do we want to use the default font?
				Font = _defaultFont ? _defaultFont : new FlxCaiBitmapFont; // If it doesn't exist yet, create it
			_font = Font;
			calcFrame();
		}
		
		/**
		 * Get the font used
		 * 
		 * @return	FlxBitmapFont	The current font
		 */
		public function get font():FlxCaiBitmapFont
		{
			return _font;
		}
		
		override public function destroy():void
		{
			super.destroy() ;
			_font = null ;
			_pixels.dispose() ;
		}
	}
}