package;

import defs.LevelDef;
import defs.ObjectDef;
import defs.ObjectDef.ObjectTypes;
import defs.TriggerDef.TriggerTypes;
import entities.Block;
import entities.Explosion;
import entities.Object;
import entities.Player;
import entities.SpikedRobot;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import inputhelper.InputHelper;
import logs.Logger;
import tmxtools.TmxRect;
import tmxtools.TmxTools;
import triggers.Destination;
import triggers.TrSpawn;
import triggers.Travel;
import triggers.Trigger;
import triggers.powerups.PuBomb;
import triggers.powerups.PuJump;
import triggers.powerups.PuSpeed;
import triggers.powerups.PuSpike;

/**
 * ...
 * @author 
 */
class TestState extends FlxState 
{
	var map:TmxTools;
	var collision:FlxTilemap;
	var bg:FlxTilemap;
	var mg:FlxTilemap;
	var fg:FlxTilemap;
	
	var levelDef:LevelDef;
	
	var player:Player;
	var triggers:FlxTypedGroup<Trigger>;
	//Objects is the generic holds for all the things the player needs to collide with
	var objects:FlxTypedGroup<Object>;
	var effects:FlxSpriteGroup;
	var hud:FlxSpriteGroup;
	
	var energyBar:FlxBar;
	
	var spawnLocation:FlxPoint;
	
	//Catch a weird problem where the robot immediately enters and leaves a room.
	var timeInLevel:Float = 0;
	
	override public function destroy():Void 
	{
		super.destroy();
		//levelDef = null; 
		//player.destroy();
		//map = null;
		//collision.destroy();
		//triggers.destroy();
		//objects.destroy();
		//effects.destroy();
		//hud.destroy();
		//energyBar.destroy();
		//spawnLocation.destroy();
	}
	
	override public function create():Void 
	{
		super.create();
		H.ALLOW_INPUT = true;
		//Create the map for the level we are on.
		map = new TmxTools('assets/data/levels/test/' + H.gs.currentLevel + '.tmx', 'assets/data/levels/test/', 'assets/data/levels/test/');
		collision = map.getMap('collision');
		collision.setTileProperties(0, FlxObject.NONE);
		bg = map.getMap('bg');
		mg = map.getMap('mg');
		fg = map.getMap('fg');
		
		
		//Create the game objects
		player = new Player();
		triggers = new FlxTypedGroup<Trigger>();
		objects = new FlxTypedGroup<Object>();
		effects = new FlxSpriteGroup();
		hud = new FlxSpriteGroup();
		hud.scrollFactor.set();
		
		
		FlxG.watch.add(player, 'energyCurrent');
		FlxG.watch.add(H.gs, 'currentLevel');
		FlxG.watch.add(H.gs, 'previousLevel');
		FlxG.watch.add(this, 'timeInLevel');
		
		
		
		var rects = map.getTmxRectanges();
		//addTriggers(rects);
		Logger.addLog('rects', rects.toString());
		//Insert items in the levelDef
		applyLevelDef();
		spawnPlayer();
		createHUD();

		
		//Add graphics.
		add(objects);
		//Add the maps if we have them.
		if (bg != null)
		add(bg);
		if (mg != null)
		add(mg);
		add(player);
		add(effects);
		if (fg != null)
		add(fg);
		add(collision);
		collision.alpha = .3;
		add(hud);
		add(triggers);
		
		//Set the camera
		setCameraParameters();
		if (H.gs.previousLevel == '')
				player.alpha = 0;

		//Fade the camera in.
		FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, true, function() {
			//If this is a spawn...
			if (H.gs.previousLevel == '') {
			new FlxTimer().start(.7, function(_) {
			//After the camera fades in, wait some time, flash the spawn, show the player, and start the game.
				H.PAUSED = false; 
				FlxG.camera.flash(FlxColor.WHITE, .1);
				player.alpha = 1;
			});
				
			} else {
				player.alpha = 1;
				H.PAUSED = false; 
				
			}
			
			
		});
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		timeInLevel += elapsed;
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

	/**
	 * Spawn player puts the player next to the spawn point or the destination point, whichever it needs to.
	 * @param	rects
	 */
	private function spawnPlayer() {
		if (H.gs.previousLevel == '') {
			//Place the player at the spawn point definition, not the actual object.  They should be the same, but weird things are happening anyway.
			for (o in levelDef.objects){
				if (o.type == ObjectTypes.SPAWN) {
					var p = H.roundToNearestTile(o.x, o.y);
					player.x = 65;
					player.y = 256;
					H.resetPlayer();
					player.setEnergy();
					return;
				}
			}
		}
		
		//var looking = H.gs.previousLevel;
	//
		for (t in triggers) {
			if (t.def.type == TriggerTypes.DESTINATION && t.def.data == H.gs.previousLevel) {
				player.x = t.x;
				player.y = t.y;
				return;
			}
		}
		//Logger.addLog('Spawn Player', 'Unable to add player to the level.  Looking for destination ' + looking, 1);
		
	}
	
	//private function addTriggers(rects:Array<TmxRect>) {
		//for (r in rects) {
			//switch (r.name) 
			//{
				//case 'travel':
					//var t = new Travel(r.type);
					//t.makeGraphic(Std.int(r.r.width), Std.int(r.r.height),FlxColor.TRANSPARENT, true);
					//var p = H.roundToNearestTile(r.r.x, r.r.y);
					//t.x = p.x;
					//t.y = p.y;
					//triggers.add(t);
				//case 'spawn':
					//var s = new TrSpawn();
					//var p = H.roundToNearestTile(r.r.x, r.r.y);
					////Spawns are 3x1, and should spawn in the ground.
					//s.x = p.x;
					//s.y = p.y;
					//triggers.add(s);
					//
				//case 'upgrade':
					//createUpgrade(r);
				//default:
					//
			//}
		//}
	//}
	
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
			if (timeInLevel < 1)
			return;
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
		if (Std.is(trigger, PuSpeed)) {
			var j = cast(trigger, PuSpeed);
			trigger.kill();
			H.gs.powerupsThis.set('speed', true);
			player.setSpeed();
		}
		if (Std.is(trigger, PuSpike)) {
			trigger.kill();
			H.gs.powerupsThis.set('spike', true);
			player.setSpeed();
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
	//private function createUpgrade(r:TmxRect) {
		//switch (r.type) 
		//{
			//case 'jump':
				//if (!H.gs.powerupsThis.get('jump')) {
					////Create the jump powerup.
					//var p = H.roundToNearestTile(r.r.x,r.r.y);
					//var jump = new PuJump(p.x, p.y);
					//triggers.add(jump);
					//Logger.addLog('Adding Powerup', 'Trying to add jump ' + jump.toString());
				//}
			//case 'bomb':
				//if (!H.gs.powerupsThis.get('bomb')) {
					////Create the jump powerup.
					//var p = H.roundToNearestTile(r.r.x,r.r.y);
					//var pu = new PuBomb(p.x, p.y);
					//triggers.add(pu);
					//Logger.addLog('Adding Powerup', 'Trying to add bomb ' + pu.toString());
				//}
			//case 'speed':
				//if (!H.gs.powerupsThis.get('speed')) {
					////Create the jump powerup.
					//var p = H.roundToNearestTile(r.r.x,r.r.y);
					//var pu = new PuSpeed();
					//pu.x = p.x;
					//pu.y = p.y;
					//triggers.add(pu);
					//Logger.addLog('Adding Powerup', 'Trying to add speed' + pu.toString());
				//}
			//case 'spike':
				//if (!H.gs.powerupsThis.get('spike')) {
					////Create the jump powerup.
					//var p = H.roundToNearestTile(r.r.x,r.r.y);
					//var pu = new PuSpike();
					//pu.x = p.x;
					//pu.y = p.y;
					//triggers.add(pu);
					//Logger.addLog('Adding Powerup', 'Trying to add spike' + pu.toString());
				//}
			//default:
				//
		//}
	//}
	
	/**
	 * Send a signal to this stage.  Normally used by the substate.
	 * @param	signal	The signal sent
	 */
	public function signalMe(signal:String) {
		switch (signal) 
		{
			case 'power down':
				Logger.addLog('power down', 'Powering down', 1);
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
		if(player.fsm == PlayerStates.NORMAL)
			player.fsm = PlayerStates.POWER_DOWN;
		else if (player.fsm == PlayerStates.SPIKED)
			player.fsm = PlayerStates.POWER_DOWN_SPIKED;
		//player.animation.play('powerdown');
		new FlxTimer().start(2, function(_) {
				FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, false, 
				function() {
					var od:ObjectDef = {
						x:player.x,
						y:player.y,
						type:ObjectTypes.ROBOT
					};
					//If we are spiked, make a spiked robot instead.
					if (player.fsm == PlayerStates.POWER_DOWN_SPIKED)
						od.type = ObjectTypes.SPIKED;
						od.data = player.flipX + '';
					
						
					objects.add(new PoweredDown(od));
					FlxDestroyUtil.destroy(player);
					H.resetPlayer();
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
		if (Std.is(o, TrSpawn)) {
			//If we are reentering the room, download the robot and create a new level.
			if (H.gs.previousLevel != '') {
				despawnRobot(cast(o, TrSpawn));
			} else {
				FlxG.collide(p, o);

			}
		}
		
		if (Std.is(p, Explosion) && cast(o, Object).def.type == ObjectTypes.BLOCK) {
			o.kill();
		}
		
		if (Std.is(o, PoweredDown) || Std.is(o, Block) || Std.is(o, SpikedRobot)) {
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
				switch (o.name) 
				{
					case 'appear':
						spawnLocation = new FlxPoint(o.r.x,o.r.y);
					case 'spawn':
						var p = H.roundToNearestTile(o.r.x, o.r.y); 
						levelDef.objects.push( {
						x:p.x,
						y:p.y,
						type:ObjectTypes.SPAWN });
						
					case 'travel':
						var p = H.roundToNearestTile(o.r.x, o.r.y); 
						levelDef.triggers.push( {
						x:p.x,
						y:p.y,
						width:o.r.width,
						height:o.r.height,
						data:o.type,
						type:TriggerTypes.TRAVEL });
					case 'd':
						var p = H.roundToNearestTile(o.r.x, o.r.y); 
						levelDef.triggers.push( {
						x:p.x,
						y:p.y,
						width:o.r.width,
						height:o.r.height,
						data:o.type,
						type:TriggerTypes.DESTINATION });
					case 'u':
						var p = H.roundToNearestTile(o.r.x, o.r.y); 
						levelDef.triggers.push( {
						x:p.x,
						y:p.y,
						width:o.r.width,
						height:o.r.height,
						data:o.type,
						type:TriggerTypes.UPGRADE});
						
					case 'blocks':
						var p = H.roundToNearestTile(o.r.x, o.r.y); 
						levelDef.objects.push( {
						x:p.x,
						y:p.y,
						type:ObjectTypes.BLOCK});
					
					default:
						
				}
			}
		} else {
			levelDef = H.gs.getLevelDef(H.gs.currentLevel);
		}
			//An array of robot objects.  Restrict the number of robots on the screen to 3, plus the active one.
			var robotObjs:Array<Object> = [];
		
		//Create the objects from the Object Definitions.
		for (obj in levelDef.objects) {
			
			switch (obj.type) 
			{
				case ObjectTypes.SPAWN:
					objects.add(new TrSpawn(obj));
				case ObjectTypes.BLOCK:
					var b = new Block(obj);
					objects.add(b);
				case ObjectTypes.ROBOT:
					var r = new PoweredDown(obj);
					robotObjs.push(r);
				case ObjectTypes.SPIKED:
					var s = new SpikedRobot(obj);
					robotObjs.push(s);
				default:
			}
			FlxG.watch.add(robotObjs, 'length');
			
		}
		//Check how many are in the array.  If there are more than 3, get rid of the first until there are only three left.
		while (robotObjs.length > 3) {
			robotObjs.shift();
		}
			
		//Add the remaining robots to the game.
		for(r in robotObjs)
		objects.add(r);

		//Create the triggers from the definitions
		for (t in levelDef.triggers) {
			switch (t.type) 
			{
				case TriggerTypes.TRAVEL:
					triggers.add(new Travel(t));
				case TriggerTypes.DESTINATION:
					triggers.add(new Destination(t));
				case TriggerTypes.UPGRADE:
					
					
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
		levelDef.triggers = [];
		for (o in objects) {
			//Loop through the objects and have them update their definitions.
			if (o.alive) {
				levelDef.objects.push(o.updateDefinition());
			}
		}
		for (t in triggers) {
			levelDef.triggers.push(t.def);
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
	 * Despawn the robot and download the data.  Then start another level.
	 */
	private function despawnRobot(spawn:TrSpawn) {
		if (!H.ALLOW_INPUT)
		return;
			H.downloadUpgrades();
			H.ALLOW_INPUT = false;
			H.PAUSED = true;
			//Prep the flash sprite.
			var flash = new FlxSprite();
			flash.frames = FlxAtlasFrames.fromTexturePackerJson('assets/images/atlas.png', 'assets/images/atlas.json');
			flash.animation.addByPrefix('flash', 'lightbeam', 1, false);
			flash.animation.play('flash');
			flash.kill();
			effects.add(flash);
			//Put the player in position
			FlxTween.linearMotion(player, player.x, player.y, spawn.x + 32, spawn.y - 60,.3, true, {ease:FlxEase.cubeOut, onComplete: function(_) {
				//Wait a second, then scan and destroy the robot.
				new FlxTimer().start(.5, function(_) {
					FlxG.camera.flash(FlxColor.WHITE, .1);
					flash.reset(spawn.x, spawn.y);
					//TODO: Flash sfx here.
					flash.velocity.y = -1000;
					//Fade the player.
					FlxTween.tween(player, {alpha:0}, .5);
					FlxTween.tween(flash, {alpha:0}, .5);
					new FlxTimer().start(2, function(_) {
						FlxG.camera.fade(FlxColor.BLACK, H.FADE_TIME, false, function() {
							H.resetPlayer();
							nextLevel();
						});
					} );
				
				} );
			} });
	}

}