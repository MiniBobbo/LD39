package tmxtools;
import flixel.math.FlxRect;
import haxe.ds.StringMap;

/**
 * @author 
 */
typedef TmxRect =
{
	var name:String;
	var r:FlxRect;
	@:optional var type:String;
	var properties:StringMap<String>;
}