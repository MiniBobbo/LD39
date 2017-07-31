package entities;

import defs.ObjectDef;
import flixel.graphics.frames.FlxAtlasFrames;

/**
 * ...
 * @author 
 */
class Generator extends Object 
{

	public function new(definition:ObjectDef) 
	{
		super(definition);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('block', 'generator', 1, false);
		animation.play('block');
		immovable = true;
		def = definition;
		x = definition.x;
		y = definition.y;

	}
	
}