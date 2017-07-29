package;
import haxe.ds.StringMap;

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
	
	
	public function new() 
	{
		//Add the powerups.
		powerupsAll = new StringMap<Bool>();
		powerupsAll.set('jump', false);
		powerupsThis = new StringMap<Bool>();
		powerupsThis.set('jump', false);
		currentLevel = '1';
		previousLevel = '';
		
	}
	
}