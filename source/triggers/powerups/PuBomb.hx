package triggers.powerups;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PuBomb extends FlxSprite 
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(32, 32, FlxColor.BLUE);
		
	}
	
}