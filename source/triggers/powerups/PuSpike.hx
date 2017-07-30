package triggers.powerups;

import defs.TriggerDef;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class PuSpike extends Trigger 
{

	public function new(def:TriggerDef) 
	{
		super(def);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('go', 'powerup', 12, true);
		animation.play('go');
		angularVelocity = 180;

	}
	
}