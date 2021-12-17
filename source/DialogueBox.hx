package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	var curSound:FlxSound;
	var curMusic:FlxSound;

	// var fadeScreen:FlxSprite;
	var blackScreen:FlxSprite;

	var whitelisted:Array<String> = [
		'killSound', 'soundoverwritestop', 'musicstop', 'music', 'musicloop', 'soundoverwrite', 'sound', 'bg', 'bghide', 'bgremove', 'makeGraphic', 'fadeIn',
		'fadeOut', 'overlayHide', 'bgOverlay', 'shakeOverlay', 'bgFadeIn', 'bgFadeOut', 'midTextFadeOut', 'playMP4', 'makeGraphicBlack', 'pause',
		'setNextDialogueFileName', 'restart', 'goToMainMenu', 'storyModeOff', 'waitFor', 'disableSkip', 'allowSkip'
	];
	var isAuto:Bool = false;
	var autoSkip:Bool = false;
	var leTimer:FlxTimer;

	var box:FlxSprite;
	var daBg:FlxSprite;
	var daBgOverlay:FlxSprite;
	var hider:FlxSprite;
	var midText:FlxText;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var extraPortraits:Array<FlxSprite> = [];

	var fadeColor:FlxColor = FlxColor.BLACK;

	public var paused:Bool = false;

	public static var inMP4:Bool = false;

	public var isFade:Bool = false;
	public var toFade:Float = 0;
	public var queueFade:Bool = false;
	public var fadeTimer:FlxTimer;

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var bgFade:FlxSprite;

	var extraCharnames:Array<String> = [
		'KunaTalk1', 'CrystalNotTalking', 'CrystalTalking', 'CrystalTalking2', 'CrystalTalking3', 'CrystalTalking4', 'BaoTalking1', 'BaoTalking2',
		'BaoTalking3', 'BaoTalking4', 'Artemis Not Talking', 'ArtemisTalking1', 'ArtemisTalking2'
	];

	var extraRights:Array<Bool> = [];

	var defaultSound:String = '';

	var killSound:Bool = false;

	var holdIndicator:FlxText;
	var holdTimer:Float = 0;

	public var done:Bool = false;

	public var accepted:Bool = false;
	public var held:Bool = false;

	public var video:MP4Handler = new MP4Handler();

	public static var canSkip:Bool = true;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, FlxG.height + 10);

		var hasDialog = false;

		hasDialog = true;
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		daBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		daBg.antialiasing = true;
		add(daBg);
		daBg.visible = false;

		daBgOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		daBgOverlay.antialiasing = true;
		daBgOverlay.visible = false;
		add(daBgOverlay);

		hider = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		hider.antialiasing = true;
		hider.alpha = 0;

		midText = new FlxText(0, 0, FlxG.width, "", 32);
		midText.setFormat(Paths.font('animeace2_reg.ttf'), 32, FlxColor.WHITE, CENTER);
		midText.screenCenter();

		box.animation.play('normalOpen');
		box.x = FlxG.width / 2 - box.width / 2;
		box.updateHitbox();

		box.y -= box.height;
		box.y += 20;
		box.x += 40;

		for (i in 0...extraCharnames.length)
		{
			var isRight:Bool = false;

			var daChar:String = extraCharnames[i];
			var newSprite = new FlxSprite(-80).loadGraphic(Paths.image('dialogue/' + daChar));
			newSprite.scale = new FlxPoint(0.5, 0.5);
			newSprite.updateHitbox();

			/*if (extraCharnames[i].toLowerCase().contains('crystal'))
				{
					isRight = true;
				}

				if (isRight)
					{
						newSprite.x += box.width;
						newSprite.x -= newSprite.width;
						// newSprite.x -= 100;
						newSprite.y -= 105;
			}*/

			if (extraCharnames[i].toLowerCase().contains('bao'))
			{
				newSprite.x += 150;
			}
			else if (extraCharnames[i].toLowerCase().contains('crystal'))
			{
				newSprite.x += 150;
				newSprite.y -= 100;
			}
			else if (extraCharnames[i].toLowerCase().contains('artemis'))
			{
				newSprite.x -= 150;
			}
			else if (extraCharnames[i].toLowerCase().contains('kuna'))
			{
				newSprite.x += 100;
				newSprite.y -= 120;
			}

			newSprite.updateHitbox();
			newSprite.scrollFactor.set();
			newSprite.visible = false;
			extraPortraits.push(newSprite);
			add(newSprite);
			extraRights.push(isRight);
		}

		add(box);

		dropText = new FlxText(242, 557, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 555, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;

		swagDialogue.setFormat(Paths.font('animeace2_reg.ttf'), 20, 0xFF3F2021, LEFT);

		add(swagDialogue);

		add(hider);
		add(midText);

		holdIndicator = new FlxText(0, 0, 0, "Hold " + #if visualControls "X" #else "S" #end + " To Skip...", 12);
		holdIndicator.setFormat('Nokia Cellphone FC Small', 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		holdIndicator.x = FlxG.width - holdIndicator.width;
		add(holdIndicator);

		dialogue = new Alphabet(0, 80, "", false, true);
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.antialiasing = true;
		add(blackScreen);

		if (fadeTimer != null)
		{
			fadeTimer.cancel();
			fadeTimer.destroy();
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.visible = false;
		dropText.alpha = 0;

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if ((!paused && !isFade) || !whitelisted.contains(curCharacter))
		{
			box.alpha = 1;
			swagDialogue.alpha = 1;
		}
		else
		{
			box.alpha = 0;
			swagDialogue.alpha = 0;
		}

		isAuto = false;

		if (curCharacter.endsWith('-auto'))
			isAuto = true;

		if ((accepted && !isAuto)
			|| (isAuto && autoSkip)
			|| (dialogueList.length > 0 && whitelisted.contains(curCharacter))
			&& dialogueStarted == true
			&& !paused
			&& !isFade)
		{
			var queuePause:Bool = false;
			queueFade = false;
			if (!paused && !isFade)
			{
				switch (curCharacter)
				{
					case 'musicloop':
						if (Paths.exists(Paths.music(dialogueList[0])))
						{
							if (curMusic != null && curMusic.playing)
							{
								curMusic.stop();
							}

							curMusic = new FlxSound().loadEmbedded(Paths.music(dialogueList[0]), true);
							curMusic.volume = 0.05;
							curMusic.play();
						}
					case 'music':
						if (Paths.exists(Paths.music(dialogueList[0])))
						{
							if (curMusic != null && curMusic.playing)
							{
								curMusic.stop();
							}

							curMusic = new FlxSound().loadEmbedded(Paths.music(dialogueList[0]), false);
							curMusic.volume = 0.05;
							curMusic.play();
						}
					case 'musicstop':
						if (curMusic != null && curMusic.playing)
						{
							curMusic.stop();
						}
					case 'soundoverwrite':
						if (Paths.exists(Paths.sound(dialogueList[0])))
						{
							if (curSound != null && curSound.playing)
							{
								curSound.stop();
							}
							curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
							// curSound.volume = FlxG.sound.volume;
							curSound.play();
						}
					case 'soundoverwritestop':
						if (curSound != null && curSound.playing)
						{
							curSound.stop();
						}
					case 'sound':
						if (Paths.exists(Paths.sound(dialogueList[0])))
						{
							FlxG.sound.play(Paths.sound(dialogueList[0]));
						}

					case 'playMP4':
						if (Paths.exists(Paths.video(dialogueList[0])))
						{
							inMP4 = true;
							PlayState.instance.canPause = false;
							video.playMP4(Paths.video(dialogueList[0]));
							video.finishCallback = function()
							{
								inMP4 = false;
							}
						}

					case 'bghide':
						daBg.visible = false;
					case 'bgremove':
						remove(daBg);

					case 'bg':
						if (Paths.exists(Paths.image(dialogueList[0])))
						{
							daBg.loadGraphic(Paths.image(dialogueList[0]));
						}
						daBg.visible = true;

					case 'makeGraphic':
						var ourArr:Array<Int> = [];
						var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
						for (shit in tempShit)
						{
							ourArr.push(Std.parseInt(shit));
						}
						if (ourArr.length == 4)
						{
							var canUse:Bool = true;
							for (fuck in 0...ourArr.length)
							{
								if (!(ourArr[fuck] <= 255 && ourArr[fuck] >= 0))
								{
									canUse = false;
								}
							}
							if (canUse)
							{
								var PACKED_COLOR = (ourArr[0] & 0xFF) << 24 | (ourArr[1] & 0xFF) << 16 | (ourArr[2] & 0xFF) << 8 | (ourArr[3] & 0xFF);
								daBg.makeGraphic(FlxG.width, FlxG.height, PACKED_COLOR);
								daBg.visible = true;
							}
						}
					case 'makeGraphicBlack':
						daBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
						daBg.visible = true;

					case 'fadeColor':
						var ourArr:Array<Int> = [];
						var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
						for (shit in tempShit)
						{
							ourArr.push(Std.parseInt(shit));
						}
						if (ourArr.length == 4)
						{
							var canUse:Bool = true;
							for (fuck in 0...ourArr.length)
							{
								if (!(ourArr[fuck] <= 255 && ourArr[fuck] >= 0))
								{
									canUse = false;
								}
							}
							if (canUse)
							{
								fadeColor = (ourArr[0] & 0xFF) << 24 | (ourArr[1] & 0xFF) << 16 | (ourArr[2] & 0xFF) << 8 | (ourArr[3] & 0xFF);
							}
						}
					case 'fadeIn':
						queueFade = true;

						camera.fade(fadeColor, Std.parseFloat(dialogueList[0]), false, function()
						{
							isFade = false;
							queueFade = false;
						}, true);
						box.alpha = 0;
						swagDialogue.alpha = 0;

					case 'fadeOut':
						queueFade = true;

						camera.fade(fadeColor, Std.parseFloat(dialogueList[0]), true, function()
						{
							isFade = false;
							queueFade = false;
						}, true);
						box.alpha = 0;
						swagDialogue.alpha = 0;

					case 'bgFadeIn':
						queueFade = true;
						FlxTween.tween(hider, {alpha: 0}, Std.parseFloat(dialogueList[0]), {
							onComplete: function(twn:FlxTween)
							{
								isFade = false;
								queueFade = false;
							}
						});
					case 'bgFadeOut':
						queueFade = true;
						FlxTween.tween(hider, {alpha: 1}, Std.parseFloat(dialogueList[0]), {
							onComplete: function(twn:FlxTween)
							{
								isFade = false;
								queueFade = false;
							}
						});
					case 'bgOverlay':
						if (Paths.exists(Paths.image(dialogueList[0])))
						{
							daBgOverlay.loadGraphic(Paths.image(dialogueList[0]));
						}
						daBgOverlay.visible = true;

					case 'overlayHide':
						daBgOverlay.visible = false;

					case 'midTextFadeOut':
						queueFade = true;
						FlxTween.tween(midText, {alpha: 0}, Std.parseFloat(dialogueList[0]), {
							onComplete: function(twn:FlxTween)
							{
								isFade = false;
								queueFade = false;
							}
						});

					case 'shakeOverlay':
						var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
						if (tempShit.length == 2)
						{
							var calc1:Float = Std.parseFloat(tempShit[0]);
							var calc2:Float = Std.parseFloat(tempShit[1]);
							if (Math.isNaN(calc1))
								calc1 = 0;
							if (Math.isNaN(calc2))
								calc2 = 0;

							FlxG.cameras.shake(calc1, calc2);
						}

					case 'setNextDialogueFileName':
						PlayState.dialogueFileName = dialogueList[0];

					case 'restart':
						{
							PlayState.startTime = 0;
							PlayState.instance.removeEvents();
							PlayState.instance.clean();
							FlxG.resetState();
							PlayState.stageTesting = false;
						}

					case 'storyModeOff':
						{
							PlayState.isStoryMode = false;
						}

					case 'waitFor':
						{
							paused = true;
							new FlxTimer().start(Std.parseFloat(dialogueList[0]), function(tmr:FlxTimer)
							{
								paused = false;
							}, 1);
						}

					case 'allowSkip':
						{
							if (!canSkip)
								canSkip = true;
						}

					case 'disableSkip':
						{
							if (canSkip)
								canSkip = false;
						}

					case 'goToMainMenu':
						{
							PlayState.startTime = 0;
							PlayState.instance.clean();
							MainMenuState.notif = "THANK YOU FOR PLAYING OUR MOD!
							WE ARE ACCEPTING DONATIONS SO IT CAN SUPPORT THE ARTISTS AND PEOPLE IN THIS PROJECT.
							HOPE TO SEE YOU AGAIN IN THE NEXT WEEK!
 							FOLLOW @blitz_crystal ON TWITTER FOR FUTURE UPDATES!\nPress [Enter] to go to our ko-fi or [ESC] to ignore this message :(";
							FlxG.switchState(new MainMenuState());
						}
					case 'killSound':
						killSound = true;
					case 'pause':
						paused = true;
				}

				if (whitelisted.contains(curCharacter))
				{
					box.alpha = 0;
					swagDialogue.alpha = 0;
				}

				remove(dialogue);

				bgFade.alpha = 0;
			}

			if ((dialogueList[1] == null && dialogueList[0] != null))
			{
				if (!isEnding && !paused && !isFade)
				{
					isEnding = true;
					blackScreen.visible = false;
					box.alpha = 0;
					bgFade.alpha = 0;
					hidePortraits();
					swagDialogue.alpha = 0;
					dropText.alpha = 0;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
						if (curMusic != null && curMusic.playing)
						{
							curMusic.stop();
						}
						if (curSound != null && curSound.playing)
						{
							curSound.stop();
						}
					});
				}
			}
			else if (!paused && !isFade)
			{
				dropText.visible = true;
				box.visible = true;
				swagDialogue.visible = true;
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
			else if (paused || isFade)
			{
				dropText.visible = false;
				box.visible = false;
				swagDialogue.visible = false;
				hidePortraits();
			}

			if (queuePause)
			{
				queuePause = false;
				paused = true;
			}

			if (queueFade)
			{
				queueFade = false;
				isFade = true;
			}
		}

		if (held)
			holdTimer += 1 / FlxG.updateFramerate;
		else
			holdTimer = 0;

		if (holdTimer >= 1 && canSkip)
		{
			blackScreen.visible = false;
			box.alpha = 0;
			bgFade.alpha = 0;
			hidePortraits();
			swagDialogue.alpha = 0;
			dropText.alpha = 0;
			finishThing();
			kill();
			if (curMusic != null && curMusic.playing)
			{
				curMusic.stop();
			}
			if (curSound != null && curSound.playing)
			{
				curSound.stop();
			}
		}

		super.update(elapsed);
	}

	function hidePortraits():Void
	{
		for (shit in extraPortraits)
		{
			shit.visible = false;
		}
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		if (!isFade && !paused)
		{
			box.visible = true;
			swagDialogue.visible = true;
		}

		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);

		hidePortraits();

		switch (curCharacter)
		{
			case 'noone':
				hidePortraits();
			case 'noone-auto':
				hidePortraits();
			/*case 'bao' | 'bao-auto' | 'noone-bao' | 'noone-bao-auto':
					defaultSound = 'baoText';
				case 'crystal' | 'crystal-auto' | 'noone-crystal' | 'noone-crystal-auto':
					defaultSound = 'crystalText';
				case 'kuna' | 'kuna-auto' | 'noone-kuna' | 'noone-kuna-auto':
					defaultSound = 'kunaText';
				case 'domo' | 'domo-auto':
					defaultSound = 'pixelText'; */
			case 'midText':
				box.visible = false;
				swagDialogue.visible = false;
				midText.text = dialogueList[0];
				midText.screenCenter();
				FlxTween.tween(midText, {alpha: 1}, 1);
		}

		var replacedChar:String = new EReg("-auto", "g").replace(curCharacter, "");

		if (extraCharnames.contains(replacedChar))
		{
			extraPortraits[extraCharnames.indexOf(replacedChar)].visible = true;
			if (!extraRights[extraCharnames.indexOf(replacedChar)])
			{
				box.flipX = true;
			}
			else
			{
				box.flipX = false;
			}
		}

		if (defaultSound != "")
		{
			if (swagDialogue.sounds != [FlxG.sound.load(Paths.sound(defaultSound), 0.6)])
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound(defaultSound), 0.6)];
			if (whitelisted.contains(replacedChar) || replacedChar == 'midText' || killSound)
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound(defaultSound), 0)];
		}

		autoSkip = false;

		var del:Float = 0.04;
		if (curCharacter.endsWith('-auto'))
			del = 0.03;

		if (leTimer != null)
		{
			leTimer.cancel();
			leTimer.destroy();
		}

		swagDialogue.start(del, true, false, null, function()
		{
			leTimer = new FlxTimer();
			var time:Float = 0.03;

			if (curSound != null && curSound.playing)
			{
				var t = curSound.length - curSound.time;
				if (t > 0)
					time = t / 1000;
			}

			/*if (inMP4)
				time = 15.0; */

			leTimer.start(time, function(tmr:FlxTimer)
			{
				if (isAuto)
					autoSkip = true;
			}, 1);
		});

		if (!whitelisted.contains(curCharacter))
		{
			blackScreen.visible = false;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
