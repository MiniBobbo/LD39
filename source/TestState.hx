package;

import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import inputhelper.InputHelper;
import logs.Logger;
import tmxtools.TmxRect;
import tmxtools.TmxTools;
import triggers.Travel;

/**
 * ...
 * @author 
 */
class TestState extends FlxState 
{
	var map:TmxTools;
	var collision:FlxTilemap;
	
	var player:Player;
	var triggers:FlxSpriteGroup;
	var hud:FlxSpriteGroup;
	
	var energyBar:FlxBar;
	
	override public function create():Void 
	{
		super.create();
		//Create the map for the level we are on.
		map = new TmxTools('assets/data/levels/test/' + H.gs.currentLevel + '.tmx', 'assets/data/levels/test/', 'assets/data/levels/test/');
		collision = map.getMap('collision');
		collision.setTileProperties(0, FlxObject.NONE);
		
		//Create the game objects
		player = new Player();
		triggers = new FlxSpriteGroup();
		hud = new FlxSpriteGroup();
		hud.scrollFactor.set();
		
		//just for fun, make a bunch of players
		for (i in 0...10) {
			var p = new Player();
			p.x = player.x + FlxG.random.float( -10, 10);
			p.y = player.y;
			hud.add(p);
		}
		
		FlxG.watch.add(player, 'energyCurrent');
		FlxG.watch.add(H.gs, 'currentLevel');
		FlxG.watch.add(H.gs, 'previousLevel');
		
		
		
		var rects = map.getTmxRectanges();
		spawnPlayer(rects);
		createHUD();
		addTriggers(rects);
		Logger.addLog('rects', rects.toString());

		
		//Add graphics.
		add(collision);
		add(player);
		add(hud);
		add(triggers);
		
		//Set the camera
		setCameraParameters();
		//Fade the camera in.
		FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, true, function() {H.PAUSED = false; });
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		InputHelper.updateKeys(elapsed);
		if (!H.PAUSED) {
			FlxG.collide(player, collision);
			FlxG.overlap(player, triggers, hitTrigger);
		}
		energyBar.percent = player.energyCurrent / player.energyMax;
		super.update(elapsed);
		
	}
	
	private function spawnPlayer(rects:Array<TmxRect>) {
		var looking = H.gs.previousLevel;
		if (looking == '')
		looking = 'spawn';
		
		for (r in rects) {
			switch (r.name) 
			{
				case 'spawn':
					if (looking == 'spawn') {
						player.x = r.r.x;
						player.y = r.r.y;
						H.resetPlayerEnergy();
						player.setEnergy();
						return;
					}
				case 'd':
					if (looking == r.type) {
						player.x = r.r.x;
						player.y = r.r.y;
						return;
					}
				default:
					Logger.addLog('Spawn Player', 'Unknown rectangle name ' + r.name,2);
			}
		}
		Logger.addLog('Spawn Player', 'Unable to add player to the level.  Looking for destination ' + looking, 1);
		
	}
	
	private function addTriggers(rects:Array<TmxRect>) {
		for (r in rects) {
			switch (r.name) 
			{
				case 'travel':
					var t = new Travel(r.type);
					t.makeGraphic(Std.int(r.r.width), Std.int(r.r.height), FlxColor.TRANSPARENT);
					t.x = r.r.x;
					t.y = r.r.y;
					triggers.add(t);
				case 'upgrade':
					createUpgrade(r);
				default:
					
			}
		}
	}
	
	/**
	 * Creates the HUD objects and adds them to the hud group
	 */
	private function createHUD() {
		energyBar = new FlxBar(0, 0, null, FlxG.width);
		energyBar.setParent(player, 'energyCurrent');
		energyBar.setRange(0, H.playerDef.energyMax);
		energyBar.numDivisions = 500;
		hud.add(energyBar);
	}
	
	/**
	 * When a player hits a trigger, this function is called.
	 * @param	a	The player.
	 * @param	trigger	The trigger that was hit.
	 */
	private function hitTrigger(a:Dynamic, trigger:Dynamic) {
		
		//If we are paused, don't hit triggers.
		if (H.PAUSED)
			return;
		if (Std.is(trigger, Travel)) {
			H.PAUSED = true;
			H.gs.previousLevel = H.gs.currentLevel;
			H.gs.currentLevel = cast(trigger, Travel).destination;
			FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, false, function() { var s = new TestState();  FlxG.switchState(s);  });
		}
	}
	
	private function setCameraParameters() {
			FlxG.camera.follow(player);
		//If the map is larger than the screen width bound the camera to the map and follow the player
		if (collision.width > FlxG.width && collision.height > FlxG.height) {
			FlxG.camera.setScrollBoundsRect(0,0,collision.width, collision.height, true);
		} else {
			//Otherwise, figure out how to center the x or y or both axis.
			//TODO fix camrea calculations for small stages
			var boundRect = new FlxRect();
			var eWidth = (FlxG.width - collision.width)/2;
			var eHeight = (FlxG.height - collision.height)/2;
			boundRect.set(-eWidth, -eHeight, collision.width + eWidth, collision.height + eHeight);
		}
	}
	
	/**
	 * Creates an upgrade on the map if one doesn't already exist.
	 * @param	r	The rect that holds the upgrade data.  Check the type
	 */
	private function createUpgrade(r:TmxRect) {
		switch (r.type) 
		{
			case 'jump':
				
			default:
				
		}
	}
}