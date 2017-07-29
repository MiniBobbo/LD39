package;
import defs.LevelDef;
import defs.PlayerDef;
import haxe.ds.StringMap;
import logs.Logger;

/**
 * ...
 * @author 
 */
class GS 
{
	public var currentLevel:String;
	public var previousLevel:String;
	
	public var powerupsAll:StringMap<Bool>;
	public var powerupsThis:StringMap<Bool>;
	public var levelDefs:StringMap<LevelDef>;
	
	public function new() 
	{
		//Add the powerups.
		powerupsAll = new StringMap<Bool>();
		powerupsAll.set('jump', true);
		powerupsAll.set('bomb', true);
		powerupsAll.set('speed', false);
		
		powerupsThis = new StringMap<Bool>();
		powerupsThis.set('jump', true);
		powerupsThis.set('bomb', true);
		powerupsThis.set('speed', false);
		
		levelDefs = new StringMap<LevelDef>();
		
		currentLevel = '1';
		previousLevel = '';
		
	}
	
	/**
	 * Resets the player variables for the next robot.
	 */
	public function nextRobot(pd:PlayerDef) {
		currentLevel = '1';
		previousLevel = '';
		for (k in powerupsAll.keys()) {
			//Set the powerupThis value to the value contained in the powerupAll value;
			powerupsThis.set(k, powerupsAll.get(k));
		}


	}

	/**
	 * Gets a level def if one exists.  Otherwise it creates a new one and returns it.
	 * @param	level	The level to pull the level definition for.
	 * @return	The LevelDef
	 */
	public function getLevelDef(level:String):LevelDef {
		if (!levelDefs.exists(level)) {
			levelDefs.set(level, {
				objects:[]
			});
			Logger.addLog('getLevelDef', 'Created level def ' + level, 2);
		}
		return levelDefs.get(level);
	}

	
	/**
	 * Sets the level def for the supplied level.
	 * @param	level		Level to set.
	 * @param	levelDef	New leveldef
	 */
	public function setLevelDef(level:String, levelDef:LevelDef) {
			levelDefs.set(level, levelDef);
			Logger.addLog('setLevelDef', 'Setting level def for level ' + level, 2);
	}
	
	/**
	 * Is this the first time we have entered this level?  
	 * @param	level	Level to check
	 * @return	True if it is.  Otherwise false
	 */
	public function firstTimeInLevel(level:String):Bool {
		Logger.addLog('LevelDef check', 'Is level ' + level + ' in def list? ' + levelDefs.toString(),2);
		return !levelDefs.exists(level);
	}
	
}