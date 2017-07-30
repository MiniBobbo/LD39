package defs;

enum ObjectTypes {
	BLOCK;
	ROBOT;
	SPIKED;
	SPAWN;
}



/**
 * @author 
 */
typedef ObjectDef =
{
	var x:Float;
	var y:Float;
	var type:ObjectTypes;
	@:optional var data:String;
	
}
