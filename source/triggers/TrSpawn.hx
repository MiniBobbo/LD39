package triggers;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class TrSpawn extends Trigger 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		makeGraphic(96, 32, FlxColor.BROWN);
		immovable = true;
		
	}
	
}