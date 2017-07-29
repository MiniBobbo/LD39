package;
import defs.PlayerDef;
import flixel.math.FlxPoint;

/**
 * Game Helper
 * @author Dave
 */

 
class H 
{
	public static var gs:GS;
	public static var playerDef:PlayerDef;
	
	static var BASE_ENERGY:Float = 30;
	static var EC_MOVE_BASE:Float = 1;
	static var EC_IDLE_BASE:Float = .1;
	static var EC_JUMP_BASE:Float = 2;
	
	public static var FADE_TIME:Float = .5;
	
	public static var PAUSED:Bool;
	public static var ALLOW_INPUT:Bool;
	
	public static var GRAVITY:Float = 300;
	public static var MOVEMENT_DRAG:Float = 1200;
	

	/**
	 * Finds the upper left point of the tile this point is in
	 * @param	x	
	 * @param	y
	 * @return	FlxPoint of the upper left of the current tile.
	 */
	public static function roundToNearestTile(x:Float, y:Float):FlxPoint {
		var xx = Std.int(x / 32);
		var yy = Std.int(y / 32);
		return FlxPoint.weak(xx*32, yy*32);
	}

	
	public static function init() {
		gs = new GS();
		playerDef = {
			energyMax:0,
			energyCurrent:0,
			ecMove:EC_MOVE_BASE,
			ecJump:EC_JUMP_BASE,
			ecIdle:EC_IDLE_BASE
		};
		//Start the game paused because the screen will fade in and unpause everything.
		PAUSED = true;
		ALLOW_INPUT = true;
	}
	
	/**
	 * Resets the player to a new robot.
	 */
	public static function resetPlayer() {
		playerDef.energyMax = BASE_ENERGY;
		playerDef.energyCurrent = BASE_ENERGY;
		gs.nextRobot(playerDef);
		gs.currentLevel = '1';
		gs.previousLevel = '';
	}
	
	/**
	 * Syncs the player upgrades with the game upgrades so all the future robots will start with the given upgrade.
	 */
	public static function downloadUpgrades() {
		for (k in gs.powerupsAll.keys()) {
			//Set the powerupAll value to the value contained in the powerupThis value;
			gs.powerupsAll.set(k, gs.powerupsThis.get(k));
		}
	}
	
	
}