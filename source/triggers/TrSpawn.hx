package triggers;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class TrSpawn extends Trigger 
{

	public function new() 
	{
		super();
		makeGraphic(96, 32, FlxColor.BROWN);
		immovable = true;
		
	}
	
}