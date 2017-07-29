package defs;

/**
 * @author 
 */
typedef PlayerDef =
{
	var energyCurrent:Float;
	var energyMax:Float;
	//ec variables are energy cost.  
	//How much emergy per second does it take to move?
	var ecMove:Float;
	//How much energy a second does it take to idle?
	var ecIdle:Float;
	//How much emergy does it take to jump?
	var ecJump:Float;

}