package triggers;

import defs.TriggerDef;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Trigger extends FlxSprite 
{
	public var def:TriggerDef;
	
	public function new(def:TriggerDef) 
	{
		super();
		this.def = def;
		makeGraphic(Std.int(def.width), Std.int(def.height), FlxColor.TRANSPARENT, true);
		x = def.x;
		y = def.y;
	}
	
		/**
	 * Updates the object definition with the current object data
	 * @return	The updated definition
	 */
	public function updateDefinition():TriggerDef {
		def.x = this.x;
		def.y = this.y;
		def.width = this.width;
		def.height = this.height;
		
		return def;
	}
	
	
}