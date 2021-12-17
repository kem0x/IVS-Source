package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.8" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'credit menu', 'options'];

	var magenta:FlxSprite;

	var bg1:FlxSprite;
	var bg2:FlxSprite;
	var scrollBG:FlxSprite;
	var scrollBG2:FlxSprite;
	var bg4:FlxSprite;

	var arrow1:FlxSprite;
	var arrow2:FlxSprite;

	var mainCam:FlxCamera;
	var higherCam:FlxCamera;
	var scrollCam1:FlxCamera;
	var scrollCam2:FlxCamera;

	var force:Bool = false;

	public static var notif:String = "";

	var isNotif:Bool = false;
	var notifText = new FlxText(0, 0, FlxG.width, "", 32);
	var notifBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	var isStory:Bool = false;
	var storyCurSelected = 0;
	var diffText:FlxText;
	var diffTexts:Array<String> = ['< EASY >', '<NORMAL>', '< HARD >'];
	var weekText:FlxText;
	var weekTexts:Array<String> = ['<TUTORIAL>'];
	var curWeek:Int = 0;
	var curDiff:Int = 0;

	static public function weekData():Array<Dynamic>
	{
		 return [['tutorial'], ['whale-waltz', 'sea-breeze', 'shark-attack']];
		//return [['tutorial'], ['shark-attack']];
	}

	public function new(Force:Bool = false)
	{
		super();
		force = Force;
	}

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		mainCam = new FlxCamera();
		mainCam.bgColor.alpha = 0;

		scrollCam1 = new FlxCamera();
		scrollCam1.bgColor.alpha = 0;

		scrollCam2 = new FlxCamera();
		scrollCam2.bgColor.alpha = 0;

		FlxG.cameras.reset(scrollCam1);
		FlxG.cameras.add(scrollCam2);
		FlxG.cameras.add(mainCam);

		higherCam = new FlxCamera();
		higherCam.bgColor.alpha = 0;

		FlxG.cameras.add(higherCam);

		FlxCamera.defaultCameras = [mainCam];

		higherCam.y -= 120;

		FlxCamera.defaultCameras = [mainCam];

		mainCam.y = -FlxG.height;
		FlxTween.tween(mainCam, {y: 0}, 1.2, {ease: FlxEase.quadOut});

		if (!FlxG.sound.music.playing || force)
		{
			FlxG.sound.playMusic(Paths.inst('whale-waltz'));
		}

		persistentUpdate = persistentDraw = true;

		bg4 = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		bg4.scrollFactor.x = 0;
		bg4.scrollFactor.y = 0.18;
		bg4.updateHitbox();
		bg4.screenCenter();
		bg4.alpha = 0;
		bg4.antialiasing = true;
		add(bg4);

		scrollBG = new FlxSprite();
		scrollBG.frames = Paths.getPackerAtlas('scrollbg');
		scrollBG.animation.addByPrefix('scroll', 'scrollbg_', 10);
		scrollBG.animation.play('scroll', true);
		scrollBG.antialiasing = true;
		scrollBG.screenCenter(X);
		scrollBG.cameras = [scrollCam1, scrollCam2];
		scrollBG.alpha = 0;
		add(scrollBG);

		scrollBG2 = new FlxSprite();
		scrollBG2.frames = Paths.getPackerAtlas('scrollbg');
		scrollBG2.animation.addByPrefix('scroll', 'scrollbg_', 10);
		scrollBG2.animation.play('scroll', true);
		scrollBG2.antialiasing = true;
		scrollBG2.screenCenter(X);
		scrollBG2.cameras = [scrollCam1, scrollCam2];
		scrollBG2.color = 0xFF00FFFF;
		scrollBG2.visible = false;
		add(scrollBG2);

		scrollCam2.focusOn(FlxPoint.get(FlxG.width / 2, -scrollBG.height + FlxG.height / 2));

		bg2 = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg2.scrollFactor.x = 0;
		bg2.scrollFactor.y = 0.18;
		// bg2.setGraphicSize(Std.int(bg4.width * 1.1));
		bg2.updateHitbox();
		bg2.alpha = 0;
		bg2.screenCenter();
		bg2.antialiasing = true;
		add(bg2);

		bg1 = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg1.scrollFactor.x = 0;
		bg1.scrollFactor.y = 0.18;
		// bg1.setGraphicSize(Std.int(bg4.width * 1.1));
		bg1.updateHitbox();
		bg1.screenCenter();
		bg1.antialiasing = true;
		add(bg1);

		magenta = new FlxSprite(bg4.x, bg4.y).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.updateHitbox();
		magenta.visible = false;
		magenta.screenCenter();
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		var tex2 = Paths.getSparrowAtlas('story_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			if (optionShit[i] == 'story mode')
				menuItem.frames = tex2;
			else
				menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter();
			menuItem.y += FlxG.height * menuItem.ID;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		arrow1 = new FlxSprite(0, 10);
		arrow1.frames = ui_tex;
		arrow1.animation.addByPrefix('idle', "arrow left");
		arrow1.animation.addByPrefix('press', "arrow push left");
		arrow1.animation.play('idle');
		arrow1.angle = 90;
		arrow1.updateHitbox();
		arrow1.screenCenter(X);
		add(arrow1);

		arrow2 = new FlxSprite(0, 0);
		arrow2.frames = ui_tex;
		arrow2.animation.addByPrefix('idle', "arrow right");
		arrow2.animation.addByPrefix('press', "arrow push right");
		arrow2.animation.play('idle');
		arrow2.angle = 90;
		arrow2.updateHitbox();
		arrow2.screenCenter(X);
		arrow2.y = FlxG.height - arrow2.height - 10;
		add(arrow2);

		changeItem();

		diffText = new FlxText((FlxG.width / 2) - 100, (FlxG.height / 2) + 195, 0, diffTexts[curDiff], 32);
		diffText.scrollFactor.set();
		diffText.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		diffText.visible = false;
		add(diffText);

		if (FlxG.save.data.finishedTut)
		{
			weekTexts.push('< WEEK 1 >');
		}

		weekText = new FlxText((FlxG.width / 2) - 120, (FlxG.height / 2) + 145, 0, weekTexts[curWeek], 32);
		weekText.scrollFactor.set();
		weekText.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		weekText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		weekText.alpha = 0.5;
		weekText.visible = false;
		add(weekText);

		if (notif != "")
		{
			isNotif = true;

			notifBg.alpha = 0;
			add(notifBg);

			notifText.alpha = 0;
			add(notifText);

			notifText.text = notif;
			notifText.setFormat(Paths.font('animeace2_reg.ttf'), 32, FlxColor.WHITE, CENTER);
			notifText.screenCenter();

			FlxTween.tween(notifText, {alpha: 1}, 1);
			FlxTween.tween(notifBg, {alpha: 0.8}, 1);
		}

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var accepted = controls.ACCEPT;
			var backed = controls.BACK;
			var upped = controls.UP_P;
			var downed = controls.DOWN_P;
			var uppedH = controls.UP;
			var downedH = controls.DOWN;
			var righted = controls.RIGHT_P;
			var lefted = controls.LEFT_P;

			if (!isNotif && !isStory)
			{
				if (upped)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (downed)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (uppedH)
					arrow1.animation.play('press');
				else
					arrow1.animation.play('idle');
				if (downedH)
					arrow2.animation.play('press');
				else
					arrow2.animation.play('idle');

				if (backed)
				{
					FlxG.switchState(new TitleState());
				}

				if (accepted)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (optionShit[curSelected] != 'story mode')
					{
						selectedSomethin = true;
						FlxTween.tween(mainCam, {zoom: 3, angle: 179}, 0.5, {ease: FlxEase.quadOut});
					}

					menuItems.forEach(function(spr:FlxSprite)
					{
						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							case 'story mode':
								{
									// FlxG.switchState(new StoryMenuState());
									isStory = true;
									diffText.visible = true;
									weekText.visible = true;
								}

							case 'freeplay':
								FlxG.switchState(new FreeplayState());

								trace("Freeplay Menu Selected");

							case 'credit menu':
								FlxG.switchState(new MenuCredits());
								trace("Credits Selected");

							case 'options':
								FlxG.switchState(new OptionsDirect());
						}
					});
				}
			}
			else if (isStory)
			{
				if (storyCurSelected == 0) // diff
				{
					diffText.alpha = 1;
					weekText.alpha = 0.5;

					if (upped)
					{
						storyCurSelected = 1;
					}

					if (righted)
					{
						curDiff++;

						if (curDiff > 2)
							curDiff = 2;
					}

					if (lefted)
					{
						curDiff--;

						if (curDiff < 0)
							curDiff = 0;
					}

					diffText.text = diffTexts[curDiff];
				}

				if (storyCurSelected == 1) // week
				{
					diffText.alpha = 0.5;
					weekText.alpha = 1;

					if (downed)
					{
						storyCurSelected = 0;
					}

					if (righted)
					{
						curWeek++;

						if (curWeek > weekTexts.length - 1)
							curWeek = weekTexts.length - 1;
					}

					if (lefted)
					{
						curWeek--;

						if (curWeek < 0)
							curWeek = 0;
					}

					weekText.text = weekTexts[curWeek];
				}

				if (accepted)
				{
					PlayState.storyPlaylist = weekData()[curWeek];
					PlayState.isStoryMode = true;
					PlayState.songMultiplier = 1;
					PlayState.isSM = false;
					PlayState.storyDifficulty = curDiff;
					var diff:String = ["-easy", "", "-hard"][PlayState.storyDifficulty];
					PlayState.sicks = 0;
					PlayState.bads = 0;
					PlayState.shits = 0;
					PlayState.goods = 0;
					PlayState.campaignMisses = 0;
					PlayState.SONG = Song.conversionChecks(Song.loadFromJson(PlayState.storyPlaylist[0], diff));
					PlayState.storyWeek = curWeek;
					PlayState.campaignScore = 0;
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						FlxTween.tween(mainCam, {zoom: 3, angle: 179}, 0.5, {ease: FlxEase.quadOut});
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
				}

				if (backed)
				{
					isStory = false;
					weekText.visible = false;
					diffText.visible = false;
				}
			}
			else
			{
				if (accepted || backed)
				{
					if (notif.toLowerCase().contains("ko-fi") && accepted) // CODISM
					{
						FlxG.openURL('https://ko-fi.com/indievtubershowdown');
					}

					FlxTween.tween(notifText, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							remove(notifText);
						}
					});

					FlxTween.tween(notifBg, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							remove(notifBg);
						}
					});

					notif = '';
					isNotif = false;
				}
			}
		}

		if (scrollBG.alpha > 0)
		{
			scrollBG.y -= 50 / FlxG.updateFramerate;

			if (scrollBG.y < -scrollBG.height)
			{
				scrollBG.y = 0;
			}
		}
		else
			scrollBG.y = 0;

		scrollBG2.x = scrollBG.x;
		scrollBG2.y = scrollBG.y;

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		var beforeSelected:Int = 0;
		beforeSelected += curSelected;

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				// camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			var toMove:Int = 0;

			var daOption:String = optionShit[curSelected];
			switch (daOption)
			{
				case 'story mode':
					if (spr.ID == beforeSelected)
						switch (optionShit[spr.ID])
						{
							case 'options':
								toMove = 1;
							case 'freeplay':
								toMove = 2;
						}
					if (spr.ID == curSelected)
						switch (optionShit[beforeSelected])
						{
							case 'options':
								toMove = 3;
							case 'freeplay':
								toMove = 4;
						}
				case 'freeplay':
					if (spr.ID == beforeSelected)
						switch (optionShit[spr.ID])
						{
							case 'story mode':
								toMove = 1;
							case 'credit menu':
								toMove = 2;
						}
					if (spr.ID == curSelected)
						switch (optionShit[beforeSelected])
						{
							case 'story mode':
								toMove = 3;
							case 'credit menu':
								toMove = 4;
						}
				case 'credit menu':
					if (spr.ID == beforeSelected)
						switch (optionShit[spr.ID])
						{
							case 'freeplay':
								toMove = 1;
							case 'options':
								toMove = 2;
						}
					if (spr.ID == curSelected)
						switch (optionShit[beforeSelected])
						{
							case 'freeplay':
								toMove = 3;
							case 'options':
								toMove = 4;
						}
				case 'options':
					if (spr.ID == beforeSelected)
						switch (optionShit[spr.ID])
						{
							case 'credit menu':
								toMove = 1;
							case 'story mode':
								toMove = 2;
						}
					if (spr.ID == curSelected)
						switch (optionShit[beforeSelected])
						{
							case 'credit menu':
								toMove = 3;
							case 'story mode':
								toMove = 4;
						}
			}

			if (toMove > 0)
			{
				var del:Float = 0.25;
				var daEase:Float->Float = FlxEase.quadOut;
				var added:Float = FlxG.height / 2 + spr.y / 2;

				switch (toMove)
				{
					case 1:
						spr.screenCenter();
						FlxTween.tween(spr, {y: spr.y - added}, del, {ease: daEase});
					case 2:
						spr.screenCenter();
						FlxTween.tween(spr, {y: spr.y + added}, del, {ease: daEase});
					case 3:
						spr.screenCenter();
						spr.y += added;
						FlxTween.tween(spr, {y: spr.y - added}, del, {ease: daEase});
					case 4:
						spr.screenCenter();
						spr.y -= added;
						FlxTween.tween(spr, {y: spr.y + added}, del, {ease: daEase});
					case 5:
						spr.y = FlxG.height * 2;
				}

				if (toMove == 3 || toMove == 4)
				{
					var toggles:Array<Float> = [0, 0, 0, 0];
					toggles[curSelected] = 1;
					FlxTween.tween(bg1, {alpha: toggles[0]}, del, {ease: daEase});
					FlxTween.tween(bg2, {alpha: toggles[1]}, del, {ease: daEase});
					FlxTween.tween(scrollBG, {alpha: toggles[2]}, del, {ease: daEase});
					FlxTween.tween(bg4, {alpha: toggles[3]}, del, {ease: daEase});
				}
			}

			spr.updateHitbox();
		});
	}
}
