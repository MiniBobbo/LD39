package triggers;

import defs.TriggerDef;

/**
 * ...
 * @author 
 */
class TrCutscene extends Trigger 
{
	public var name:String;
	public function new(def:TriggerDef) 
	{
		super(def);
		name = def.data;
	}
	
}