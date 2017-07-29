package;

import flixel.FlxGame;
import inputhelper.InputHelper;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		InputHelper.init();
		InputHelper.allowArrowKeys();
		InputHelper.allowWASD();
		InputHelper.addButton('jump');
		InputHelper.addButton('action');
		InputHelper.assignKeyToButton('SPACE', 'jump');
		InputHelper.assignKeyToButton('ENTER', 'action');
		
		
		H.init();
		addChild(new FlxGame(0, 0, TestState));
	}
}
