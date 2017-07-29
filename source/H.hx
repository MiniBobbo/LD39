package;
import defs.PlayerDef;

/**
 * ...
 * @author 
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
	}
	
	public static function resetPlayerEnergy() {
		playerDef.energyMax = BASE_ENERGY;
		playerDef.energyCurrent = BASE_ENERGY;
	}
	
}