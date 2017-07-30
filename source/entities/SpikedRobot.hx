package entities;

import defs.ObjectDef;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SpikedRobot extends Object 
{

	public function new(definition:ObjectDef) 
	{
		super(definition);
		super(definition);
		makeGraphic(32, 32, FlxColor.PURPLE);
		immovable = true;
		def = definition;
		x = definition.x;
		y = definition.y;

	}
	
}