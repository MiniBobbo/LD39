package;

import defs.ObjectDef;
import defs.ObjectDef.ObjectTypes;
import entities.Object;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PoweredDown extends Object 
{
	
	
	public function new(objectDef:ObjectDef) 
	{
		super(objectDef);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByNames('powered down', ['robot_powerdown_124.png'], 1, false);
		animation.play('powered down');
		setSize(30, 20);
		this.centerOffsets();

		x = objectDef.x;
		//TODO: Fix hack that places the powered down object higher to avoid it falling through the floor.  
		y = objectDef.y;
		acceleration.y = H.GRAVITY;
		drag.x = H.MOVEMENT_DRAG;
		
	}
	override public function update(elapsed:Float):Void 
	{
		//if (H.PAUSED || !H.ALLOW_INPUT)
		//return;
		super.update(elapsed);
	}
	
}