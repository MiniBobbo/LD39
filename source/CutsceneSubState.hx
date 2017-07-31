package;

import defs.CutsceneDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
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
	
	var g:FlxSpriteGroup;
	
	
	public function new(cutsceneName:String) 
	{
		super();
		csd = H.cutscenes.get(cutsceneName);
		messages = csd.messages.copy();
		
	}
	
	override public function create():Void 
	{
		super.create();
		g = new FlxSpriteGroup();
		g.scrollFactor.set();
		var bg = new FlxSprite();
		
		bg.frames = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
		bg.y = 0;
		bg.animation.addByPrefix('screen', 'screen', 1, false);
		bg.animation.play('screen');
		//bg.centerOffsets();
		g.add(bg);

		t = new FlxTypeText(35, 55, 500, 'THIS IS A TEST', 16, true);
		t.delay = H.TYPETEXT_DELAY;
		t.showCursor = true;
		t.cursorBlinkSpeed = 1.0;
		t.sounds = [
		FlxG.sound.load('assets/sounds/type1.wav', 0.3),
		FlxG.sound.load('assets/sounds/type2.wav', 0.3)
		];
		
		g.add(t);
		add(g);
		//g.screenCenter();
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
		if (FlxG.keys.justPressed.ESCAPE) {
			messages = [];
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