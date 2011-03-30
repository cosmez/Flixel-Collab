package collab.ui 
{
	import org.flixel.* ;
	import collab.Resources ;
	
	/**
	 * ...
	 * @author David Grace
	 */
	public class SelectorButton extends FlxObject
	{
		protected var _normalButton:FlxObject, _litButton:FlxObject, _disabledButton:FlxObject ;
		
		protected var _onClick:Function ;
		
		protected var _enabled:Boolean ;
		
		protected var _selected:Boolean = false ;
		
		public function SelectorButton(X:int, Y:int, Width:int, Height:int, normalButton:FlxObject, litButton:FlxObject, disabledButton:FlxObject, onClick:Function, enabled:Boolean = true) 
		{
			super(X, Y, Width, Height);
			
			_normalButton = normalButton ;
			
			_litButton = litButton ;
			
			_disabledButton = disabledButton ;
			
			_enabled = enabled ;
			
			_onClick = onClick ;
		}
		
		override public function render():void
		{
			// Do rendering ourselves
			if (_selected)
				_litButton.render() ;
			else if (!_enabled && _disabledButton)
				_disabledButton.render() ;
			else
				_normalButton.render() ;
		}
		
		public function set selected(v:Boolean):void 
		{
			_selected = v ;
		}
		
		public function get selected():Boolean
		{
			return _selected ;
		}
		
		public function set enabled(v:Boolean):void
		{
			_enabled = v ;
		}
		
		public function get enabled():Boolean
		{
			return _enabled ;
		}
		
		public function run():void
		{
			if (_onClick != null)
				_onClick() ;
		}
		
		static public function select(whichGroup:FlxGroup, whichButton:SelectorButton):void
		{
			// Search for this selector and then make it the active button
			for each (var obj:FlxObject in whichGroup.members)
			{
				if (obj && obj is SelectorButton)
				{
					if (obj == whichButton)
						(obj as SelectorButton).selected = true ;
					else
						(obj as SelectorButton).selected = false ;
				}
			}
		}
		
		static public function getSelectedButton(whichGroup:FlxGroup):SelectorButton
		{
			for each (var obj:FlxObject in whichGroup.members)
			{				
				if (obj && obj is SelectorButton)
				{
					var sb:SelectorButton = (obj as SelectorButton) ;
					if (sb.selected)
						return (sb) ;
				}
			}
			return null ;
		}
		
		static public function getNextButton (whichGroup:FlxGroup, currentButton:SelectorButton):SelectorButton
		{
			var buttons:Array = getButtonList(whichGroup) ;
			
			// Find out where we are in this array
			var currIndex:int = buttons.indexOf (currentButton) ;
			currIndex = (currIndex + 1) % buttons.length ;
			return (buttons[currIndex]) ;
		}
		
		static public function getPrevButton (whichGroup:FlxGroup, currentButton:SelectorButton):SelectorButton
		{
			var buttons:Array = getButtonList(whichGroup) ;
			
			// Find out where we are in this array
			var currIndex:int = buttons.indexOf (currentButton) ;
			currIndex-- ;
			if (currIndex < 0)
				currIndex = buttons.length - 1 ;
			return (buttons[currIndex]) ;
		}
		
		static public function updateButtons(whichGroup:FlxGroup):void
		{
			var currSelected:SelectorButton ;
			var nextSelected:SelectorButton ;

			// Just have our current button on standby
			currSelected = SelectorButton.getSelectedButton (whichGroup) ;
			if (!currSelected)
				throw new Error ("Something bad happened, we expect at least one SelectorButton to be active at all times!") ;
			
			// Move up the selector list
			if (FlxG.keys.justPressed ("UP"))
			{
				nextSelected = SelectorButton.getPrevButton (whichGroup, currSelected) ;					
				if (nextSelected != currSelected)
				{
					currSelected.selected = false ;
					nextSelected.selected = true ;
					FlxG.play(Resources.SFX_MOVE_CURSOR, 0.4);
				}
			}
			
			// Move down the selector list
			if (FlxG.keys.justPressed ("DOWN"))
			{
				nextSelected = SelectorButton.getNextButton (whichGroup, currSelected) ;					
				if (nextSelected != currSelected)
				{
					currSelected.selected = false ;
					nextSelected.selected = true ;
					FlxG.play(Resources.SFX_MOVE_CURSOR, 0.4);
				}
			}
			
			// 'Kay, now that keyboard faggotry is out of the way, do mouse stuff
			
			// We must loop through our buttons and see if the mouse overlaps any of them, if so, move selected to that button
			var buttons:Array = getButtonList (whichGroup) ;
			
			var overButton:Boolean = false ;
			
			for each (var tested:SelectorButton in buttons)
			{
				// If only FlxRect had 'contains'...  OH WAIT IT DOES NOW.
				if (tested.contains (FlxG.mouse.x, FlxG.mouse.y))
				{
					overButton = true ;
					// If we're not the selected button, then adjust to this button
					if (tested != currSelected)
					{
						tested.selected = true ;
						FlxG.play(Resources.SFX_MOVE_CURSOR, 0.4);
						
						// Set all other buttons to false
						for each (var other:SelectorButton in buttons)
						{
							if (other != tested)
								other.selected = false ;
						}
					}
				}				
			}
			
			if ((FlxG.mouse.justPressed() && overButton) || FlxG.keys.justPressed("ENTER"))
			{
				// Woot, button selected
				currSelected.run() ;
				FlxG.play (Resources.SFX_CONFIRM, 0.5) ;
			}
		}
		
		static private function getButtonList(whichGroup:FlxGroup):Array
		{
			var buttons:Array = new Array ;
			
			// Build a list of all buttons			
			for each (var obj:FlxObject in whichGroup.members)
			{				
				if (obj && obj is SelectorButton)
				{
					var sb:SelectorButton = obj as SelectorButton ;
					if (sb.enabled)
						buttons.push (sb) ;
				}
			}
			return (buttons) ;
		}
		
		
		
	}

}