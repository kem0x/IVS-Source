package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import flixel.FlxCamera;
#if FEATURE_DISCORD
import Discord.DiscordClient;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	// var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var bao:Character;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var defCam:FlxCamera;
	var scrollCam1:FlxCamera;
	var scrollCam2:FlxCamera;

	override public function create():Void
	{
		isReady = false;

		defCam = new FlxCamera();
		defCam.bgColor.alpha = 0;
		scrollCam1 = new FlxCamera();
		scrollCam1.bgColor.alpha = 0;
		scrollCam2 = new FlxCamera();
		scrollCam2.bgColor.alpha = 0;

		FlxG.cameras.reset(scrollCam1);
		FlxG.cameras.add(scrollCam2);
		FlxG.cameras.add(defCam);

		FlxCamera.defaultCameras = [defCam];

		PlayerSettings.init();

		#if desktop
		DiscordClient.initialize();
		#end

		@:privateAccess
		{
			Debug.logTrace("We loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets into the default library");
		}

		FlxG.autoPause = false;

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		KeyBinds.keyCheck();
		// It doesn't reupdate the list before u restart rn lmao

		NoteskinHelpers.updateNoteskins();

		if (FlxG.save.data.volDownBind == null)
			FlxG.save.data.volDownBind = "MINUS";
		if (FlxG.save.data.volUpBind == null)
			FlxG.save.data.volUpBind = "PLUS";

		FlxG.sound.muteKeys = [FlxKey.fromString(FlxG.save.data.muteBind)];
		FlxG.sound.volumeDownKeys = [FlxKey.fromString(FlxG.save.data.volDownBind)];
		FlxG.sound.volumeUpKeys = [FlxKey.fromString(FlxG.save.data.volUpBind)];

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		FlxGraphic.defaultPersist = FlxG.save.data.cacheImages;

		MusicBeatState.initSave = true;

		Highscore.load();

		super.create();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			/*if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;*/
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var isReady:Bool = false;

	public var onceBullshit:Bool = false;

	public static var scrollPixelsPerSecond:Float = 50;

	var scrollBG:FlxSprite;

	// var scrBGFollow:FlxSprite;
	var logoBl:FlxSprite;
	// var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			#if html5
			openfl.utils.ByteArray.loadFromFile('assets/songs/whale-waltz/Inst.' + Paths.SOUND_EXT).onComplete(function(daByteArray:openfl.utils.ByteArray)
			{
			#end
				#if html5
				FlxG.sound.playMusic(openfl.media.Sound.fromAudioBuffer(lime.media.AudioBuffer.fromBytes(daByteArray)), 0);
				#else
				FlxG.sound.playMusic(Paths.inst('whale-waltz'), 0);
				#end

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			#if html5
			});
			#end
		}

		Conductor.changeBPM(180);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.cameras = [scrollCam1, scrollCam2];
		add(bg);

		scrollBG = new FlxSprite();
		scrollBG.frames = Paths.getPackerAtlas('scrollbg');
		scrollBG.animation.addByPrefix('scroll', 'scrollbg_', 10);
		scrollBG.animation.play('scroll', true);
		scrollBG.antialiasing = true;
		scrollBG.screenCenter(X);
		scrollBG.cameras = [scrollCam1, scrollCam2];
		add(scrollBG);

		scrollCam2.focusOn(FlxPoint.get(FlxG.width / 2, -scrollBG.height + FlxG.height / 2));

		logoBl = new FlxSprite(-50, -50);
		logoBl.frames = Paths.getPackerAtlas('bomp (2)');
		logoBl.antialiasing = true;
		logoBl.animation.addByIndices('bump', 'bomp (2)_', [7, 8, 0, 1, 2, 3, 4, 5, 6], "", 24, false);
		logoBl.animation.play('bump', true);
		logoBl.updateHitbox();
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		bao = new Character(0, 0, "bao", true);
		var baoScale:Float = 0.6;
		bao.scale.set(baoScale, baoScale);
		bao.updateHitbox();
		bao.y = FlxG.height - bao.height;
		bao.x = FlxG.width - bao.width;
		bao.y -= 170;
		bao.x -= 120;
		bao.visible = false;
		add(bao);

		#if ((visualControls && !desktop && !web) || (!visualControls))
		FlxG.mouse.visible = false;
		#end

		if (initialized)
			skipIntro();
		else
			initialized = true;

		isReady = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (isReady)
		{
			#if debug
			if (controls.RESET)
			{
				initialized = false;
				FlxG.switchState(new TitleState());
			}
			#end
			if (FlxG.sound.music != null)
				Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

			#if mobile
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
				{
					pressedEnter = true;
				}
			}
			#end

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.START)
					pressedEnter = true;

				#if switch
				if (gamepad.justPressed.B)
					pressedEnter = true;
				#end
			}

			if (pressedEnter && !transitioning && skippedIntro)
			{
				titleText.animation.play('press');

				defCam.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
			}

			if (!onceBullshit && pressedEnter)
			{
				onceBullshit = true;
				FlxG.switchState(new MainMenuState());
				FlxTween.tween(FlxG.camera, {zoom: 0.6, alpha: -0.6}, 0.7, {ease: FlxEase.quartInOut});
				FlxTween.tween(logoBl, {alpha: 0}, 0.7, {ease: FlxEase.quartInOut});
			}

			if (pressedEnter && !skippedIntro)
			{
				skipIntro();
			}

			if (initialized)
			{
				scrollBG.visible = true;
				logoBl.visible = true;

				scrollBG.y -= scrollPixelsPerSecond / FlxG.updateFramerate;

				if (scrollBG.y < -scrollBG.height)
				{
					scrollBG.y = 0;
				}
			}
			else
			{
				scrollBG.visible = false;
				logoBl.visible = false;
			}
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (isReady)
		{
			logoBl.animation.play('bump', true);
			/*danceLeft = !danceLeft;

				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft'); */

			FlxG.log.add(curBeat);

			switch (curBeat)
			{
				case 2:
					createCoolText(['IVS Team']);
				case 3:
					addMoreText('Presents');
				case 6:
					deleteCoolText();
					createCoolText(['The']);
				case 8:
					addMoreText("FNF Mod");
					addMoreText("about VTubers");
				case 10:
					deleteCoolText();
					createCoolText(['Ayo']);
				case 11:
					addMoreText("You're a star!");
				case 12:
					deleteCoolText();
					createCoolText(['FNF']);
				case 13:
					addMoreText("Indie");
				case 14:
					addMoreText("VTuber");
				case 15:
					addMoreText("Showdown");
				case 17:
					deleteCoolText();
					createCoolText(['LETS GO']);
					bao.visible = true;
					bao.animation.play('go', true);
				case 20:
					bao.visible = false;
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			defCam.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
