package triggers;

import defs.TriggerDef;

/**
 * ...
 * @author 
 */
class TrText extends Trigger 
{
	var display:String;
	public function new(def:TriggerDef) 
	{
		super(def);
		display = def.data;
	}
	
}