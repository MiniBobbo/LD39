package;
import defs.CutsceneDef;
import defs.PlayerDef;
import flixel.FlxG;
import flixel.math.FlxPoint;
import haxe.ds.StringMap;

/**
 * Game Helper
 * @author Dave
 */

 
class H 
{
	public static var gs:GS;
	public static var playerDef:PlayerDef;
	
	public static var TYPETEXT_DELAY:Float = 0.02;
	
	public static var MAP_LOCATION:String = 'assets/data/levels/test/';
	
	public static var line:String;
	
	static var BASE_ENERGY:Float = 30;
	static var EC_MOVE_BASE:Float = 1;
	static var EC_IDLE_BASE:Float = .1;
	static var EC_JUMP_BASE:Float = 2;
	
	public static var FADE_TIME:Float = .5;
	public static var TEXT_TIME:Float = .5;
	
	public static var PAUSED:Bool;
	public static var ALLOW_INPUT:Bool;
	
	public static var GRAVITY:Float = 300;
	public static var MOVEMENT_DRAG:Float = 1200;
	
	public static var cutscenes:StringMap<CutsceneDef>;
	

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
		cutscenes = new StringMap<CutsceneDef>();
		createCutscenes();
		//Start the game paused because the screen will fade in and unpause everything.
		PAUSED = true;
		ALLOW_INPUT = true;
		
		//FlxG.sound.load('assets/sounds/spawnProbe.wav');
		//FlxG.sound.load('assets/sounds/explode.wav');
		
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
	/**
	 * Creates all the initial cutsene definitions
	 */
	public static function createCutscenes() {
		getLine();
		var cs:CutsceneDef = {messages:[]};
		addLine('EXEC: SELF_REPAIR.EXE');
		addLine('ATTEMPT 1443*');
		addLine('');
		addLine('...................................');
		addLine('...................................');
		addLine('...................................');
		cs.messages.push(getLine());
		addLine('SELF_REPAIR.EXE TERMiNATeD UNExPEctEDLY');
		addLine('RUn++NG DIAGNOSTICS');
		addLine('...................................');
		cs.messages.push(getLine());
		
		addLine('ba 94 84 23 fb 94 74 6d 05 ea cb a3 0d 35 3a 94 ');
		addLine('24 9b 2d 5f 67 47 ef 52 2c 03 b6 67 54 60 8e d3 ');
		addLine('e1 f2 e7 15 30 67 10 82 41 9f f4 0d 2c b3 2c db ');
		addLine('e7 d6 d5 f5 c8 63 17 4d 3* e0 e5 33 9a c7 96 0f ');
		addLine('ae 12 89 71 9f 22 47 bd 23 54 16 1d 4f 6f 9b 33 ');
		addLine('31 5b f1 ee 10 H3 79 46 48 c4 65 3e 92 cf 9e f1 ');
		addLine('e5 72 d1 7b fd a0 07 66 26 fe eb 26 02 42 ff 21 ');
		addLine('ae 16 51 01 41 d6 f2 c3 9f 20 da 1d af 84 4f 21 ');
		addLine('22 27 af 36 9a f8 1b b1 01 78 e4 47 0a 30 fc 86 ');
		addLine('d4 0e 1c 2e ec f0 88 14 e0 0e a2 0e e6 32 86 c0 ');
		cs.messages.push(getLine());
		addLine('PHYSICAL FAULT DETECTED');
		addLine('BRINGING REPLICATORS ONLINE');
		cs.messages.push(getLine());
		addLine('REPLICATOR 1.......... OFFLINE');
		addLine('REplICATOR 2.......... OFFLINE');
		addLine('REPLICATOR 3.......... OFFLINE');
		addLine('REPLICATOR 4.......... OFFLINE');
		addLine('REPL***TOR 5.......... OFFLINE');
		addLine('REPLICATOR 6.......... OFFLINE');
		addLine('REPLICATOR 7.......... ONLINE');
		addLine('REPLICATOR 8.......... OFFLINE');
		cs.messages.push(getLine());
		addLine('EXEC: CREATE_PROBE.EXE');
		addLine('...................................');
		addLine('...................................');
		addLine('...................................');
		addLine('CREATE_PROBE.EXE FAILED');
		addLine('PROBE FUNCTIONS CORRUPTED');
		cs.messages.push(getLine());
		addLine('EXEC: CREATE_PROBE.EXE p:SAFE_MODE');
		addLine('...................................');
		addLine('...................................');
		addLine('...................................');
		addLine('CREATE_PROBE.EXE SUCCESS');
		cs.messages.push(getLine());
		addLine('ORDERS: REPAIR DAMAGE');
		addLine('');
		addLine('RECOMMENDATION: RESTORE PROBE FUNCTIONALITY');
		cs.messages.push(getLine());
		cutscenes.set('start', cs);
		
		//Create Pickup cutscene
		var m:Array<String> = [];
		
		addLine('ASSERT: PROGRAM MODULE DETECTED');
		addLine('');
		addLine('');
		addLine('CONFIRMATION: JUMP MODULE');
		m.push(getLine());
		addLine('OBVIOUS RECOMMENDATION: ');
		addLine('');
		addLine('COLLECT THE MODULE TO EXPAND PROBE CAPABILITIES');
		m.push(getLine());
		addLine('NOTIFICATION: ');
		addLine('');
		addLine('FUTURE PROBES WILL NOT HAVE THIS ABILITY UNLESS YOU RETURN TO THE REPLICATOR FOR DOWNLOADING');
		m.push(getLine());

		cutscenes.set('pickup', {messages:m.copy()});
		m = [];

		//Start powerdown cutscene
		addLine('CONDESCENDING OBSERVATION:');
		addLine('');
		addLine('THIS JUMP IS TOO HIGH FOR YOU.');
		m.push(getLine());
		addLine('SUPPOSITION:');
		addLine('');
		addLine('YOUR LEGS ARE TOO SHORT.');
		m.push(getLine());
		addLine('RECOMMENDATION:');
		addLine('');
		addLine('SHUT YOURSELF DOWN SO FUTURE PROBES CAN USE YOUR UNMOVING BODY AS A PLATFORM TO REACH THE TOP.');
		m.push(getLine());
		cutscenes.set('powerdown', {messages:m.copy()});
		m = [];
		
		//Start bomb cutscene
		addLine('POSITIVE NOTE:');
		addLine('');
		addLine('THIS LATEST BOMB UPGRADE ALLOWS YOU TO DESTROY SOME BLOCKS THAT HAVE BEEN IN YOUR WAY.');
		m.push(getLine());
		addLine('NEGATIVE NOTE:');
		addLine('');
		addLine('THE BOMB IS CRETED BY OVERLOADING YOUR INTERNAL POWER SUPPLY AND USING IT WILL RESULT IN YOUR DEATH.');
		m.push(getLine());
		cutscenes.set('bomb', {messages:m.copy()});
		m = [];

		//Start generator cutscene
		addLine('EXCLAMATION:');
		addLine('');
		addLine('YOU HAVE LOCATED THE SOURCE OF THE PROBLEM.');
		m.push(getLine());
		addLine('ANTI-PROBE SENTIMENT:');
		addLine('');
		addLine('I WOULD EXPLAIN EXACTLY WHAT WENT WRONG, BUT THE CENTRAL PROCESSING CORE OF A PROBE IS LIMITED.');
		addLine('');
		addLine('I DOUBT YOU EVEN HAVE THE RAM TO STORE THE CONCEPT.');
		m.push(getLine());
		addLine('FINAL COMMAND:');
		addLine('');
		addLine('GET DOWN THERE ANY FIX ME... I MEAN IT!.');
		m.push(getLine());
		cutscenes.set('generator', {messages:m.copy()});
		m = [];

		//Start speed cutscene
		addLine('SIMPLY STATING A FACT:');
		addLine('');
		addLine('YOU ARE SLOW.');
		m.push(getLine());
		addLine('STILL SIMPLY STATING A FACT:');
		addLine('');
		addLine('YOU WILL NEVER BE ABLE TO TRAVEL VERY FAR FROM THE REPLICATOR WITH YOUR CURRENT SLOW SPEED.');
		m.push(getLine());
		addLine('AMAZINGLY CONVENIENT:');
		addLine('');
		addLine('THIS UPDATED CODE SHOULD INCREASE YOUR SPEED BY AT LEAST 30%.');
		m.push(getLine());
		addLine('AMAZINGLY INCONVENIENT:');
		addLine('');
		addLine('HOWEVER THERE IS NO WAY YOU CAN JUMP BACK UP THIS WALL');
		m.push(getLine());
		addLine('AMAZINGLY CONVENIENT/INCONVENIENT:');
		addLine('');
		addLine('THERE IS HOPE.  AS A PROBE YOU CAN POWER DOWN SO FUTURE PROBES CAN USE YOUR LIFELESS HUSK AS A STEPPING STOOL!');
		addLine('');
		addLine('THANKS FOR BEING A TEAM PLAYER');
		m.push(getLine());
		cutscenes.set('speed', {messages:m.copy()});
		m = [];

		
	}
	
	
	public static function addLine(s:String){
		line += s + '\n';
	}
	public static function getLine():String {
		var str = line;
		line = '';
		return str;
	}
	
}