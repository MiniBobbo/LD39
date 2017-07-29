package entities;

import defs.ObjectDef;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Object extends FlxSprite 
{
	public  var def:ObjectDef;
	
	public function new(definition:ObjectDef ) 
	{
		super();
		this.def = definition;
	}
	
	override public function update(elapsed:Float):Void 
	{
		x = Math.round(x);
		y = Math.round(y);
		super.update(elapsed);
	}
	
	/**
	 * Updates the object definition with the current object data
	 * @return	The updated definition
	 */
	public function updateDefinition():ObjectDef {
		def.x = this.x;
		def.y = this.y;
		
		return def;
	}
	
}