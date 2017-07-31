package entities;

import flixel.FlxG;
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
		//Logger.addLog('Explode', 'Trying to explode at ' + origin,2);
		makeGraphic(96, 96, FlxColor.RED);
		FlxG.sound.play('assets/sounds/explode.wav');
		x = origin.x - 48;
		y = origin.y - 48;
		
		
	}
	
}