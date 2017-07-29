package entities;

import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.FlxAccelerometer;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import inputhelper.InputHelper;

/**
 * ...
 * @author 
 */
class Player extends Entity 
{
	var GRAVITY:Float = 400;
	var JUMP_STRENGTH:Float = 300;
	var JUMP_TIME:Float = .5;
	var MOVEMENT_ACCEL:Float = 1200;
	var MOVEMENT_DRAG:Float = 1200;
	var MOVEMENT_MAX_X:Float = 100;
	var MOVEMENT_MAX_Y:Float = 500;
	
	
	
	public var energyCurrent:Float;
	public var energyMax:Float;
	
	var I = InputHelper;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super();
		//makeGraphic(30, 30, FlxColor.BLUE);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		animation.addByPrefix('walk', 'robot_walk', 61);
		animation.addByPrefix('idle', 'robot_idle', 30);
		animation.play('idle');
		setSize(30, 30);
		
		//Set the player's settigns here.
		//Gravity.
		acceleration.y = GRAVITY;
		maxVelocity.set(MOVEMENT_MAX_X, MOVEMENT_MAX_Y);
		
		drag.x = MOVEMENT_DRAG;
		
		setEnergy();
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		//If we are paused, don't do anything.
		if (H.PAUSED)
		return;
		//Energy spent is how much energy was spent this frame
		var energySpent = H.playerDef.ecIdle * elapsed;
		//Subtract the energy we have used.

		
		//Set the x acceleration to 0.
		acceleration.x = 0;
		if (I.isButtonPressed('left')) {
			acceleration.x -= MOVEMENT_ACCEL;
			energySpent += H.playerDef.ecMove * elapsed;
		} 
		if (I.isButtonPressed('right')) {
			acceleration.x += MOVEMENT_ACCEL;
			energySpent += H.playerDef.ecMove * elapsed;
		} 
		if (I.isButtonJustPressed('jump') && isTouching(FlxObject.FLOOR)) {
			//Only run the jump code if we have the jump upgrade.
			if (!H.gs.powerupsThis.get('jump')) {
				velocity.y -= JUMP_STRENGTH;
				energySpent += H.playerDef.ecIdle;
			}
			
		}
		
		//Figure out what animation state we should be playing.
		if (!isTouching(FlxObject.FLOOR)) {
			animation.play('idle');
		} else if (acceleration.x != 0) {
			animation.play('walk');
		} else {
			animation.play('idle');
		}
		
		if (acceleration.x > 0)
			flipX = false;
		if (acceleration.x < 0)
		flipX = true;
		//subtract all the energy used this frame
		energyCurrent -= energySpent;
		H.playerDef.energyCurrent = energyCurrent;
		
		super.update(elapsed);
	}
	
	/**
	 * Sets the player's current energy level. This can be changed by powerups.
	 */
	public function setEnergy() {
		energyCurrent = H.playerDef.energyCurrent;
		energyMax = H.playerDef.energyMax;
	}
}