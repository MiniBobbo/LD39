package;

import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class AbortState extends FlxSubState 
{
	var ui:FlxSpriteGroup;
	
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();
		ui = new FlxSpriteGroup();
		//Count the number of buttons
		var buttonCount:Int = 0;
			var disentigrateButton = new FlxButton(0, 40 * buttonCount, 'Disentigrate', disentigrate);
			disentigrateButton.label.size = 20;
			disentigrateButton.makeGraphic(200,50,FlxColor.BLUE);
			disentigrateButton.label.color = FlxColor.WHITE;
			ui.add(disentigrateButton);
			buttonCount++;

		var powerDownButton = new FlxButton(0, 60 * buttonCount, 'Power Down', powerDown);
			powerDownButton.label.size = 20;
			powerDownButton.makeGraphic(200,50,FlxColor.BLUE);
			powerDownButton.label.color = FlxColor.WHITE;
		ui.add(powerDownButton);
		buttonCount++;
		if (H.gs.powerupsThis.get('bomb')) {
			var bombButton = new FlxButton(0, 60 * buttonCount, 'Explode', explode);
			bombButton.label.size = 20;
			bombButton.label.color = FlxColor.WHITE;
			bombButton.makeGraphic(200,50,FlxColor.BLUE);
			ui.add(bombButton);
			buttonCount++;
		}
		
		
		var cancelButton = new FlxButton(0, 60 * buttonCount, "Cancel", cancel);
			cancelButton.label.size = 20;
			cancelButton.makeGraphic(200,50,FlxColor.BLUE);
			cancelButton.label.color = FlxColor.WHITE;
		ui.add(cancelButton);
		ui.x = 300;
		ui.y = 100;
		ui.scrollFactor.set();
		
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