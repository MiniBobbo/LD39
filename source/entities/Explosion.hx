package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import logs.Logger;

/**
 * ...
 * @author 
 */
class Explosion extends FlxSprite 
{

	public function new(origin:FlxPoint) 
	{
		super();
		Logger.addLog('Explode', 'Trying to eplode at ' + origin,2);
		makeGraphic(96, 96, FlxColor.RED);
		x = origin.x - 48;
		y = origin.y - 48;
		
		
	}
	
}