package;

import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class AbortState extends FlxSubState 
{
	var ui:FlxTypedGroup<FlxButton>;
	
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();
		ui = new FlxTypedGroup<FlxButton>();
		//Count the number of buttons
		var buttonCount:Int = 0;
			var disentigrateButton = new FlxButton(0, 40 * buttonCount, 'Disentigrate', disentigrate);
			ui.add(disentigrateButton);
			buttonCount++;

		var powerDownButton = new FlxButton(0, 40 * buttonCount, 'Power Down', powerDown);
		ui.add(powerDownButton);
		buttonCount++;
		if (H.gs.powerupsThis.get('bomb')) {
			var bombButton = new FlxButton(0, 40 * buttonCount, 'Explode', explode);
			ui.add(bombButton);
			buttonCount++;
		}
		
		
		var cancelButton = new FlxButton(0, 40 * buttonCount, "Cancel", cancel);
		ui.add(cancelButton);
		
		
		add(ui);
	}
	
	/**
	 * Closes this substate
	 */
	private function cancel() {
		H.PAUSED = false;
		_parentState.closeSubState();
	}
	
	/**
	 * Sends a power down signal to the parent state.
	 */
	private function powerDown() {
		var ps = cast(_parentState, TestState);
		ps.signalMe('power down');
		H.PAUSED = false;
		
		_parentState.closeSubState();
	}
	private function explode() {
		var ps = cast(_parentState, TestState);
		ps.signalMe('explode');
		_parentState.closeSubState();
	}
	private function disentigrate() {
		var ps = cast(_parentState, TestState);
		ps.signalMe('disentigrate');
		_parentState.closeSubState();
	}
	
	
	
}