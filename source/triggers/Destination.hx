package triggers;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * This trigger is a destination that comes from another screen.
 * @author  Dave
 */
class Destination extends FlxSprite 
{

	public var from:String;
	
	/**
	 * Destination triggers are spawn locations for the player when coming from another screen
	 * @param	from	The player should appear here when coming from what destination?
	 */
	public function new(from:String) 
	{
		super();
		this.from = from;
	}
	
}