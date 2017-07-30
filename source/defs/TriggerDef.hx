package defs;

enum TriggerTypes {
	UPGRADE;
	TRAVEL;
	DESTINATION;
}

/**
 * @author 
 */
typedef TriggerDef =
{
	var x:Float;
	var y:Float;
	var width:Float; 
	var height:Float;
	var type:TriggerTypes;
	@:optional var data:String;
	
}
