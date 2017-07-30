package entities;

import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.FlxAccelerometer;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import inputhelper.InputHelper;

enum PlayerStates {
	NORMAL;
	SPIKED;
}

/**
 * ...
 * @author 
 */
class Player extends Entity 
{
	public var GRAVITY:Float = 400;
	var JUMP_STRENGTH:Float = 300;
	var JUMP_TIME:Float = .5;
	var MOVEMENT_ACCEL:Float = 1200;
	var MOVEMENT_DRAG:Float = 1200;
	var MOVEMENT_MAX_X:Float = 150;
	var MOVEMENT_MAX_Y:Float = 500;
	
	var currentMovementMaxX:Float;
	
	public var energyCurrent:Float;
	public var energyMax:Float;
	
	//Finite state machine to hold the player state
	public var fsm:PlayerStates;
	public var lastFsm:PlayerStates;
	
	var I = InputHelper;
	
	public function new(X:Float=-100, Y:Float=0) 
	{
		super();
		//makeGraphic(30, 30, FlxColor.BLUE);
		var atlasFrames  = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		frames = atlasFrames;
		fsm = PlayerStates.NORMAL;
		lastFsm = PlayerStates.NORMAL;
		animation.addByPrefix('walk', 'robot_walk', 61);
		animation.addByPrefix('idle', 'robot_idle', 30);
		animation.play('idle');
		setSize(30, 30);
		centerOffsets();
		//Set the player's settings here.
		//Gravity.
		acceleration.y = GRAVITY;
		setSpeed();
		
		drag.x = MOVEMENT_DRAG;
		
		setEnergy();
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		//If we are paused, don't do anything.
		if (H.PAUSED)
		return;
		
		//If the fsm state changed, adjust movement values
		if (fsm != lastFsm) {
			changeMovementValues();
		}
		lastFsm = fsm;
		
		
		//Energy spent is how much energy was spent this frame
		var energySpent = H.playerDef.ecIdle * elapsed;
		//Subtract the energy we have used.

		acceleration.x = 0;

		if(H.ALLOW_INPUT)
			energySpent = getInputs(elapsed, energySpent);
			
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
	
	function getInputs(elapsed:Float, energySpent:Float):Float
	{
		//First, check if we used the spike
		if (I.isButtonJustPressed('action')) {
			//If we are spiked, return to normal
			if (fsm == PlayerStates.SPIKED)
				fsm = PlayerStates.NORMAL;
			//If we aren't on the ground and touching a wall, use the spike if we have it.
			if (!isTouching(FlxObject.FLOOR) && isTouching(FlxObject.WALL) && H.gs.powerupsThis.get('spike')) {
				fsm = PlayerStates.SPIKED;
			}
		}
		
		if(fsm == PlayerStates.NORMAL) {
		//Set the x acceleration to 0.
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
			if (H.gs.powerupsThis.get('jump')) {
				velocity.y -= JUMP_STRENGTH;
				energySpent += H.playerDef.ecIdle;
			}
		}
		}
		if (I.isButtonPressed('powerup'))
		energySpent -= 100 * elapsed;
		if (I.isButtonPressed('powerdown'))
		energySpent += 100 * elapsed;
		
		return energySpent;
	}
	
	/**
	 * Upgrades the speed of the robots.  Really, just increases their max speed.  Doesn't affect acceleration.
	 * @param	change  How much should the max speed change?
	 */
	public function setSpeed() {
		var spd = MOVEMENT_MAX_X;
		if (H.gs.powerupsThis.get('speed'))
			spd += 50;
		
		maxVelocity.set(spd, MOVEMENT_MAX_Y);

	}
	
	/**
	 * Changes the movement values based on the player state.
	 */
	private function changeMovementValues() {
		switch (fsm) 
		{
			case PlayerStates.NORMAL:
				acceleration.y = GRAVITY;
			case PlayerStates.SPIKED:
				acceleration.y = 0;
				velocity.y = 0;
			default:
				
		}
	

	}
}