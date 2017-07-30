package entities;

import defs.ObjectDef;
import flixel.graphics.frames.FlxAtlasFrames;
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
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('spike', 'robot_spike', 30);
		animation.play('spike');

		immovable = true;
		def = definition;
		x = definition.x;
		y = definition.y;

	}
	
}