package;

import defs.CutsceneDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import inputhelper.InputHelper;
import logs.Logger;

/**
 * ...
 * @author 
 */
class CutsceneSubState extends FlxSubState 
{
	var csd:CutsceneDef;
	var t:FlxTypeText;
	var messages:Array<String>;
	
	
	public function new(cutsceneName:String) 
	{
		super();
		var bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);
		FlxTween.tween(bg, {alpha:.4}, .5);
		csd = H.cutscenes.get(cutsceneName);
		messages = csd.messages.copy();
		Logger.addLog('cutscene', 'messages: ' + messages.toString(), 1);
		
	}
	
	override public function create():Void 
	{
		super.create();
		t = new FlxTypeText(0, 0, 500, 'THIS IS A TEST', 16, true);
		t.screenCenter();
		t.y -= 200;
		t.x -= 250;
		t.delay = H.TYPETEXT_DELAY;
		t.showCursor = true;
		t.cursorBlinkSpeed = 1.0;
		t.sounds = [
		FlxG.sound.load('assets/sounds/type1.wav'),
		FlxG.sound.load('assets/sounds/type2.wav')
		];
		
		add(t);
		//t.start();
		nextMessage();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		InputHelper.updateKeys(elapsed);
		if (InputHelper.isButtonJustPressed('jump')) {
			nextMessage();
		}
		
	}
	
	///**
	 //* Sets up the next message.
	 //*/
	private function nextMessage() {
		//If the message queue is empty, leave this state.
		if (messages.length == 0)
		_parentState.closeSubState();
		else {
		//return;
		//t.text = messages.shift();
		t.resetText(messages.shift());
		//t.resetText("This is a test of the typing.");
		t.start();
		//(H.TYPETEXT_DELAY, true, false, null, finishedTyping);
		}
		
	}
	
	private function finishedTyping() {
		
	}
}