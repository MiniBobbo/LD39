package;

import defs.LevelDef;
import defs.ObjectDef.ObjectTypes;
import entities.Block;
import entities.Explosion;
import entities.Object;
import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import inputhelper.InputHelper;
import logs.Logger;
import tmxtools.TmxRect;
import tmxtools.TmxTools;
import triggers.TrSpawn;
import triggers.Travel;
import triggers.powerups.PuBomb;
import triggers.powerups.PuJump;

/**
 * ...
 * @author 
 */
class TestState extends FlxState 
{
	var map:TmxTools;
	var collision:FlxTilemap;
	
	var levelDef:LevelDef;
	
	var player:Player;
	var triggers:FlxSpriteGroup;
	//Objects is the generic holds for all the things the player needs to collide with
	var objects:FlxTypedGroup<Object>;
	var hud:FlxSpriteGroup;
	
	var energyBar:FlxBar;
	
	override public function create():Void 
	{
		super.create();
		H.ALLOW_INPUT = true;
		//Create the map for the level we are on.
		map = new TmxTools('assets/data/levels/test/' + H.gs.currentLevel + '.tmx', 'assets/data/levels/test/', 'assets/data/levels/test/');
		collision = map.getMap('collision');
		collision.setTileProperties(0, FlxObject.NONE);
		
		//Create the game objects
		player = new Player();
		triggers = new FlxSpriteGroup();
		objects = new FlxTypedGroup<Object>();
		hud = new FlxSpriteGroup();
		hud.scrollFactor.set();
		
		
		
		FlxG.watch.add(player, 'energyCurrent');
		FlxG.watch.add(H.gs, 'currentLevel');
		FlxG.watch.add(H.gs, 'previousLevel');
		
		
		
		var rects = map.getTmxRectanges();
		spawnPlayer(rects);
		createHUD();
		addTriggers(rects);
		Logger.addLog('rects', rects.toString());
		//Insert items in the levelDef
		applyLevelDef();

		
		//Add graphics.
		add(collision);
		add(objects);
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
			FlxG.overlap(player, triggers, hitTrigger);
			FlxG.overlap(player, objects, hitObject);
			
		}
		if (InputHelper.isButtonJustPressed('abort')){
			var ss = new AbortState();
			this.openSubState(ss);
			H.PAUSED = true;
		}
		energyBar.percent = player.energyCurrent / player.energyMax;
		super.update(elapsed);
			FlxG.collide(player, collision);
			FlxG.collide(player, collision);
			FlxG.collide(objects, collision);
			FlxG.collide(objects, objects);
			//FlxG.collide(objects, objects);
		//If the energy drops below 0, power down.
		if (player.energyCurrent <= 0 && !H.PAUSED)
			powerDownRobot();
		
		
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
						H.resetPlayer();
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
				case 'spawn':
					var s = new TrSpawn();
					var p = H.roundToNearestTile(r.r.x, r.r.y);
					//Spawns are 3x1, and should spawn in the ground.
					s.x = p.x - 32;
					s.y = p.y + 32;
					triggers.add(s);
					
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
			FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, false, function() { nextLevel(); });
		}
		if (Std.is(trigger, PuJump)) {
			var j = cast(trigger, PuJump);
			trigger.kill();
			H.gs.powerupsThis.set('jump', true);
		}
		if (Std.is(trigger, PuBomb)) {
			var j = cast(trigger, PuBomb);
			trigger.kill();
			H.gs.powerupsThis.set('bomb', true);
		}
		if (Std.is(trigger, TrSpawn)) {
			var j = cast(trigger, TrSpawn);
			H.downloadUpgrades();
			FlxG.collide(a, j);
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
				if (!H.gs.powerupsThis.get('jump')) {
					//Create the jump powerup.
					var p = H.roundToNearestTile(r.r.x,r.r.y);
					var jump = new PuJump(p.x, p.y);
					triggers.add(jump);
					Logger.addLog('Adding Powerup', 'Trying to add jump ' + jump.toString());
				}
			case 'bomb':
				if (!H.gs.powerupsThis.get('bomb')) {
					//Create the jump powerup.
					var p = H.roundToNearestTile(r.r.x,r.r.y);
					var pu = new PuBomb(p.x, p.y);
					triggers.add(pu);
					Logger.addLog('Adding Powerup', 'Trying to add bomb ' + pu.toString());
				}
			default:
				
		}
	}
	
	/**
	 * Send a signal to this stage.  Normally used by the substate.
	 * @param	signal	The signal sent
	 */
	public function signalMe(signal:String) {
		switch (signal) 
		{
			case 'power down':
				powerDownRobot();
			case 'explode':
				H.ALLOW_INPUT = false;
				var explode = new Explosion(FlxPoint.weak(player.x + player.width / 2, player.y + player.height / 2));
				player.visible = false;
				add(explode);
				FlxG.overlap(explode, objects, hitObject);
				FlxTween.tween(explode, {alpha:0});
				new FlxTimer().start(1.2, function(_) {
					H.resetPlayer();
					nextLevel();
				}
				
				);
			case 'disentigrate':
				H.ALLOW_INPUT = false;
				
				
			default:
				
		}
	}
	
	/**
	 * Powers down the robot.
	 */
	public function powerDownRobot() {
		H.ALLOW_INPUT = false;
		new FlxTimer().start(2, function(_) {
				FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, false, 
				function() {
					var od = {
						x:player.x,
						y:player.y,
						type:ObjectTypes.ROBOT
					};
					objects.add(new PoweredDown(od));
					H.resetPlayer();
					//var ld = H.gs.getLevelDef(H.gs.currentLevel);
					//ld.poweredDown.push({
						//x:player.x,
						//y:player.y,
						//state:PoweredDownStates.NORMAL,
						//flipX:player.flipX
					//});
					nextLevel();
					
				});
		});
	}
	
	/**
	 * Handles collisions between the player and another game object
	 * @param	p	Player object, but passed as a FlxObject.
	 * @param	o	Object collided with.
	 */
	public function hitObject(p:FlxObject, o:FlxObject) {
		Logger.addLog('Hit' , 'Hit between ' + p.toString() + ' and ' + o.toString(), 2);
		if (Std.is(p, Explosion) && cast(o, Object).def.type == ObjectTypes.BLOCK) {
			o.kill();
		}
		
		if (Std.is(o, PoweredDown) || Std.is(o, Block)) {
			FlxG.collide(p,o);
		}
		
	}
	
	private function applyLevelDef() {
		//Check if this is the first time in the level.  If not, create a level def.
		if (H.gs.firstTimeInLevel(H.gs.currentLevel)) {
			Logger.addLog('Creating level def', 'This is the first time entereing level ' + H.gs.currentLevel, 3);
			//Gets a blank levelDef
			levelDef = H.gs.getLevelDef(H.gs.currentLevel);
			//Create any objects.
			for (o in map.getTmxRectanges()) {
				if (o.name == 'blocks') {
					var p = H.roundToNearestTile(o.r.x, o.r.y); 
					levelDef.objects.push( {
						x:p.x,
						y:p.y,
						type:ObjectTypes.BLOCK
					});
				}
			}
		} else {
			Logger.addLog('Creating level def', 'Reentering level ' + H.gs.currentLevel, 3);
			levelDef = H.gs.getLevelDef(H.gs.currentLevel);
			
		}
		
		//Create the objects from the Object Definitions.
		for (obj in levelDef.objects) {
			switch (obj.type) 
			{
				case ObjectTypes.BLOCK:
					var b = new Block(obj);
					objects.add(b);
				case ObjectTypes.ROBOT:
					var r = new PoweredDown(obj);
					objects.add(r);
				default:
					
			}
		}
	}
	
	/**
	 * Loops through all the objects in the current level and writes their data to the current level's levelDef
	 * This is generally done when transitioning out of a level.
	 */
	private function updateLevelDef() {
		//clear all the objects.
		levelDef.objects = [];
		for (o in objects) {
			//Loop through the objects and have them update their definitions.
			if (o.alive) {
				levelDef.objects.push(o.updateDefinition());
			}
		}
	}
	
	/**
	 * Us this intead of FlxG.SwitchState().  Updates the levelDef with the details of the level as your are leaving it
	 * before switching to the new state.
	 */
	private function nextLevel() {
		updateLevelDef();
		var s = new TestState();  
		FlxG.switchState(s);  
		
	}
	
	/**
	 * Run the separate multiple times to make sure we don't get any weird overlaps.
	 * @param	a
	 * @param	b
	 */
	private function multiSeparate(a:FlxObject, b:FlxObject) {
		
	}
}