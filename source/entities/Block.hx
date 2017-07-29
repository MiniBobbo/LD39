package entities;

import defs.ObjectDef;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Block extends Object 
{
	
	public function new(definition:ObjectDef) 
	{
		super(definition);
		makeGraphic(32, 32, FlxColor.YELLOW);
		immovable = true;
		def = definition;
		x = definition.x;
		y = definition.y;
		
	}
	
	
	
}