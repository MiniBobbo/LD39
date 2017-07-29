package triggers;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Travel extends FlxSprite 
{
	public var destination:String;
	public function new(destination:String) 
	{
		super();
		this.destination = destination;
		
	}
	
}