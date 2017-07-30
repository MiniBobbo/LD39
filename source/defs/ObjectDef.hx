package defs;

enum ObjectTypes {
	BLOCK;
	ROBOT;
	SPIKED;
}

/**
 * @author 
 */
typedef ObjectDef =
{
	var x:Float;
	var y:Float;
	var type:ObjectTypes;
	@:optional var age:Int;
	
}