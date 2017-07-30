package triggers;

import defs.TriggerDef;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Travel extends Trigger 
{
	public var destination:String;
	public function new(def:TriggerDef) 
	{
		super(def);
		this.destination = def.data;
		
	}
	
}