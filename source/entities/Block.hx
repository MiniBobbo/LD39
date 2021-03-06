package entities;

import defs.ObjectDef;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
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
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('block', 'block', 1, false);
		animation.play('block');
		immovable = true;
		def = definition;
		x = definition.x;
		y = definition.y;
		
	}
	
	
	
}