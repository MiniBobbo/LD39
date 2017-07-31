package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class WinState extends FlxState 
{
	var t:FlxText;
	
	override public function create():Void 
	{
		super.create();
		t = new FlxText(0, 700, FlxG.width, '', 30);
		t.text = 'Computers are jerks.\n\n\n\nMade for Ludum Dare 39 in 48 hours by Dave (MiniBobbo).\n\n\nThanks for playing!!';
		t.setFormat(null, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		FlxG.sound.load('assets/sounds/win.wav');
		FlxG.sound.play('assets/sounds/win.wav');
		add(t);
		FlxG.camera.flash(FlxColor.RED, 2.5);
		FlxG.camera.shake(.1, 2.5, function() {FlxTween.tween(t,{y:100}, 20); });
	}
	
}