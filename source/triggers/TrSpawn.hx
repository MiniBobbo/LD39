package triggers;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class TrSpawn extends Trigger 
{

	public function new() 
	{
		super();
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('normal', 'spawn', 12, true);
		animation.addByPrefix('flash', 'spawn', 12, false);
		animation.play('normal');
		immovable = true;
		setSize(96, 32);
		
	}
	
}