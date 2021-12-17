package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Stage extends MusicBeatState
{
	public var curStage:String = '';
	public var camZoom:Float; // The zoom of the camera to have at the start of the game
	public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
	public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
	public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
	// Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
	public var swagBacks:Map<String,
		Dynamic> = []; // Store BGs here to use them later (for example with slowBacks, using your custom stage event or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game))
	public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; // Store Groups
	public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in stepHit/beatHit function of this file!!)
	public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment)
	public var slowBacks:Map<Int,
		Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"

	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// All of the above must be set or used in your stage case code block!!
	public var positions:Map<String, Map<String, Array<Int>>> = [
		// Assign your characters positions on stage here!
		'green-room' => ['crystal' => [1643, 450], 'domo' => [637, 860], 'kuna-nospeakers' => [1038, 296]],
		'stage' => [
			'kuna' => [255, 321],
			'bao' => [-160, 517],
			'crystal' => [982, 450],
			'crystal-nervy' => [982, 450]
		],
		'shark' => ['kuna' => [255, 321], 'shark' => [-160, 517], 'crystal' => [982, 450]],
	];

	public function new(daStage:String)
	{
		super();
		this.curStage = daStage;
		camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
		if (PlayStateChangeables.Optimize)
			return;

		switch (daStage)
		{
			case 'green-room':
				{
					camZoom = 0.9;
					var mirror:FlxSprite = new FlxSprite().loadGraphic(Paths.image('greenRoomMirror'));
					mirror.antialiasing = true;
					swagBacks['mirror'] = mirror;
					toAdd.push(mirror);

					var walls = new FlxSprite().loadGraphic(Paths.image('greenRoomWalls'));
					walls.antialiasing = true;
					swagBacks['walls'] = walls;
					toAdd.push(walls);

					var floor:FlxSprite = new FlxSprite().loadGraphic(Paths.image('greenRoomFloor'));
					floor.antialiasing = true;
					swagBacks['floor'] = floor;
					toAdd.push(floor);

					var boombox = new FlxSprite(891, 434);
					boombox.frames = Paths.getSparrowAtlas('boombox');
					boombox.animation.addByPrefix('idle', 'boombox', 24, false);
					boombox.antialiasing = true;
					swagBacks['boombox'] = boombox;
					toAdd.push(boombox);
					animatedBacks.push(boombox);

					var chairs:FlxSprite = new FlxSprite().loadGraphic(Paths.image('greenRoomChairs'));
					chairs.antialiasing = true;
					swagBacks['chairs'] = chairs;
					toAdd.push(chairs);
				}
			case 'stage':
				{
					camZoom = 0.5;

					var bg:FlxSprite = new FlxSprite(-753, -696).loadGraphic(Paths.loadImage('sharkBG'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var screen:FlxSprite = new FlxSprite(-768, -138).loadGraphic(Paths.image('sharkScreen'));
					screen.antialiasing = true;
					screen.active = false;
					swagBacks['screen'] = screen;
					toAdd.push(screen);

					var fg:FlxSprite = new FlxSprite(-752, -691).loadGraphic(Paths.image('sharkGround'));
					fg.antialiasing = true;
					fg.active = false;
					fg.scrollFactor.set(0.5, 1);
					swagBacks['fg'] = fg;
					toAdd.push(fg);

					var speaker1 = new FlxSprite(-716, 297);
					speaker1.frames = Paths.getSparrowAtlas('speaker');
					speaker1.animation.addByPrefix('idle', 'speaker', 15, false);
					speaker1.antialiasing = true;
					swagBacks['speaker1'] = speaker1;
					toAdd.push(speaker1);
					animatedBacks.push(speaker1);

					var speaker2 = new FlxSprite(1410, 296);
					speaker2.frames = Paths.getSparrowAtlas('speaker2');
					speaker2.animation.addByPrefix('idle', 'speaker', 15, false);
					speaker2.antialiasing = true;
					swagBacks['speaker2'] = speaker2;
					toAdd.push(speaker2);
					animatedBacks.push(speaker2);

					var crowd = new FlxSprite(-805, 935);
					crowd.frames = Paths.getSparrowAtlas('crowd');
					crowd.animation.addByPrefix('idle', 'crowd', 15, false);
					crowd.antialiasing = true;
					swagBacks['crowd'] = crowd;
					toAdd.push(crowd);
					animatedBacks.push(crowd);

					var centerLights:FlxSprite = new FlxSprite(-775, -781).loadGraphic(Paths.image('sharkLights'));
					centerLights.antialiasing = true;
					swagBacks['centerLights'] = centerLights;
					toAdd.push(centerLights);
					animatedBacks.push(centerLights);

					var light:FlxSprite = new FlxSprite(-776, -729).loadGraphic(Paths.image('sharkFrontLights'));
					light.antialiasing = true;
					swagBacks['light'] = light;
					toAdd.push(light);
					animatedBacks.push(light);
				}
			case 'shark':
				{
					camZoom = 0.5;

					var bg:FlxSprite = new FlxSprite(-753, -696).loadGraphic(Paths.loadImage('sharkBG'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var screen:FlxSprite = new FlxSprite(-768, -138).loadGraphic(Paths.image('sharkScreen'));
					screen.antialiasing = true;
					screen.active = false;
					swagBacks['screen'] = screen;
					toAdd.push(screen);

					var shark = new FlxSprite(-194, -55);
					shark.frames = Paths.getSparrowAtlas('shorkpng');
					shark.animation.addByPrefix('idle', 'bounce', 15, false);
					shark.antialiasing = true;
					swagBacks['shark'] = shark;
					toAdd.push(shark);
					animatedBacks.push(shark);

					var fg:FlxSprite = new FlxSprite(-752, -691).loadGraphic(Paths.image('sharkCrack'));
					fg.antialiasing = true;
					fg.active = false;
					fg.scrollFactor.set(0.5, 1);
					swagBacks['fg'] = fg;
					toAdd.push(fg);

					var speaker1 = new FlxSprite(-716, 297);
					speaker1.frames = Paths.getSparrowAtlas('speaker');
					speaker1.animation.addByPrefix('idle', 'speaker', 15, false);
					speaker1.antialiasing = true;
					swagBacks['speaker1'] = speaker1;
					toAdd.push(speaker1);
					animatedBacks.push(speaker1);

					var speaker2 = new FlxSprite(1410, 296);
					speaker2.frames = Paths.getSparrowAtlas('speaker2');
					speaker2.animation.addByPrefix('idle', 'speaker', 15, false);
					speaker2.antialiasing = true;
					swagBacks['speaker2'] = speaker2;
					toAdd.push(speaker2);
					animatedBacks.push(speaker2);

					var crowd = new FlxSprite(-805, 935);
					crowd.frames = Paths.getSparrowAtlas('crowd');
					crowd.animation.addByPrefix('idle', 'crowd', 15, false);
					crowd.antialiasing = true;
					swagBacks['crowd'] = crowd;
					toAdd.push(crowd);
					animatedBacks.push(crowd);

					var centerLights:FlxSprite = new FlxSprite(-775, -781).loadGraphic(Paths.image('sharkLights'));
					centerLights.antialiasing = true;
					swagBacks['centerLights'] = centerLights;
					toAdd.push(centerLights);
					animatedBacks.push(centerLights);

					var light:FlxSprite = new FlxSprite(-776, -729).loadGraphic(Paths.image('sharkFrontLights'));
					light.antialiasing = true;
					swagBacks['light'] = light;
					toAdd.push(light);
					animatedBacks.push(light);
				}
			default:
				{
					camZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.loadImage('stageback', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('stagefront', 'shared'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('stagecurtains', 'shared'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = FlxG.save.data.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					swagBacks['stageCurtains'] = stageCurtains;
					toAdd.push(stageCurtains);
				}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case 'philly':
					if (trainMoving)
					{
						trainFrameTiming += elapsed;

						if (trainFrameTiming >= 1 / 24)
						{
							updateTrainPos();
							trainFrameTiming = 0;
						}
					}
					// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (!PlayStateChangeables.Optimize)
		{
			var array = slowBacks[curStep];
			if (array != null && array.length > 0)
			{
				if (hideLastBG)
				{
					for (bg in swagBacks)
					{
						if (!array.contains(bg))
						{
							var tween = FlxTween.tween(bg, {alpha: 0}, tweenDuration, {
								onComplete: function(tween:FlxTween):Void
								{
									bg.visible = false;
								}
							});
						}
					}
					for (bg in array)
					{
						bg.visible = true;
						FlxTween.tween(bg, {alpha: 1}, tweenDuration);
					}
				}
				else
				{
					for (bg in array)
						bg.visible = !bg.visible;
				}
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (FlxG.save.data.distractions && animatedBacks.length > 0)
		{
			for (bg in animatedBacks)
				bg.animation.play('idle', true);
		}

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case 'halloween':
					if (FlxG.random.bool(Conductor.bpm > 320 ? 100 : 10) && curBeat > lightningStrikeBeat + lightningOffset)
					{
						if (FlxG.save.data.distractions)
						{
							lightningStrikeShit();
							trace('spooky');
						}
					}
				case 'school':
					if (FlxG.save.data.distractions)
					{
						swagBacks['bgGirls'].dance();
					}
				case 'limo':
					if (FlxG.save.data.distractions)
					{
						swagGroup['grpLimoDancers'].forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});

						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
					}
				case "philly":
					if (FlxG.save.data.distractions)
					{
						if (!trainMoving)
							trainCooldown += 1;

						if (curBeat % 4 == 0)
						{
							var phillyCityLights = swagGroup['phillyCityLights'];
							phillyCityLights.forEach(function(light:FlxSprite)
							{
								light.visible = false;
							});

							curLight = FlxG.random.int(0, phillyCityLights.length - 1);

							phillyCityLights.members[curLight].visible = true;
							// phillyCityLights.members[curLight].alpha = 1;
						}
					}

					if (curBeat % 8 == 4 && FlxG.random.bool(Conductor.bpm > 320 ? 150 : 30) && !trainMoving && trainCooldown > 8)
					{
						if (FlxG.save.data.distractions)
						{
							trainCooldown = FlxG.random.int(-4, 0);
							trainStart();
							trace('train');
						}
					}
			}
		}
	}

	// Variables and Functions for Stages
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var curLight:Int = 0;

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2, 'shared'));
		swagBacks['halloweenBG'].animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (PlayState.boyfriend != null)
		{
			PlayState.boyfriend.playAnim('scared', true);
			PlayState.gf.playAnim('scared', true);
		}
		else
		{
			GameplayCustomizeState.boyfriend.playAnim('scared', true);
			GameplayCustomizeState.gf.playAnim('scared', true);
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var trainSound:FlxSound;

	function trainStart():Void
	{
		if (FlxG.save.data.distractions)
		{
			trainMoving = true;
			trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;

				if (PlayState.gf != null)
					PlayState.gf.playAnim('hairBlow');
				else
					GameplayCustomizeState.gf.playAnim('hairBlow');
			}

			if (startedMoving)
			{
				var phillyTrain = swagBacks['phillyTrain'];
				phillyTrain.x -= 400;

				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;

					if (trainCars <= 0)
						trainFinishing = true;
				}

				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}
	}

	function trainReset():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (PlayState.gf != null)
				PlayState.gf.playAnim('hairFall');
			else
				GameplayCustomizeState.gf.playAnim('hairFall');

			swagBacks['phillyTrain'].x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (FlxG.save.data.distractions)
		{
			var fastCar = swagBacks['fastCar'];
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCar.visible = false;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.distractions)
		{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1, 'shared'), 0.7);

			swagBacks['fastCar'].visible = true;
			swagBacks['fastCar'].velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}
}
