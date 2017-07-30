package triggers;

import defs.ObjectDef;
import defs.TriggerDef;
import entities.Object;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class TrSpawn extends Object 
{

	public function new(def:ObjectDef) 
	{
		super(def);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('normal', 'spawn', 12, true);
		animation.addByPrefix('flash', 'spawn', 12, false);
		animation.play('normal');
		immovable = true;
		setSize(96, 32);
		x = def.x;
		y = def.y;
	}
	
}