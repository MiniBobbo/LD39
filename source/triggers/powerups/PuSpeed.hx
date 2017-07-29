package triggers.powerups;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class PuSpeed extends FlxSprite 
{

	public function new() 
	{
		super();
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('go', 'powerup', 12, true);
		//animation.play('go');
		angularVelocity = 180;
		
	}
	
}