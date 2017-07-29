package;

import flixel.FlxGame;
import inputhelper.InputHelper;
import logs.Logger;
import openfl.display.Sprite;

class Main extends Sprite
{
	var TEST:Bool = true;
	
	public function new()
	{
		super();
		InputHelper.init();
		InputHelper.allowArrowKeys();
		InputHelper.allowWASD();
		InputHelper.addButton('jump');
		InputHelper.addButton('action');
		InputHelper.addButton('abort');
		InputHelper.addButton('powerup');
		InputHelper.addButton('powerdown');
		InputHelper.assignKeyToButton('SPACE', 'jump');
		InputHelper.assignKeyToButton('ENTER', 'action');
		InputHelper.assignKeyToButton('Q', 'abort');
		InputHelper.assignKeyToButton('P', 'powerup');
		InputHelper.assignKeyToButton('O', 'powerdown');
		Logger.setLogDisplayLevel(2);
		
		H.init();
		if (TEST) {
			//Logger.addLog('Test State', 'Adding test state ');
			//H.gs.powerupsAll.set('jump', true);
			//H.gs.currentLevel = 2 + '';
			//H.gs.previousLevel = 1 + '';
		}
		
		addChild(new FlxGame(0, 0, TestState));
	}
}
