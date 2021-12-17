package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxGradient;
#if windows
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;

using StringTools;

//Originally by: https://github.com/ash237/starlight-mayehem/blob/main/source/MenuCredits.hx
class MenuCredits extends MusicBeatState
{
	var songs:Array<String> = [];
	var titles:Array<String> = [];
	var icons:Array<String> = [];
	var lazyShit:Alphabet;

	var selector:FlxText;

	public static var curSelected:Int = 0;
	public static var curSelectedInCat:Int = 0;

	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpTitles:FlxTypedGroup<Alphabet>;
	private var grpSocials:FlxTypedGroup<Alphabet>;

	private var socialCatagory:Array<Int> = [];
	var socialLink:Array<String> = [];
	var socialNames:Array<String> = [];
	var dumbPersonArray:Array<Int> = [];


	var curCatagory:Int = 0;
	var inCat:Bool = false;
	var realLength:Int = 0;
	var catLength:Int = 0;

	private var curPlaying:Bool = false;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('menuBGDesat'));
	//var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Free_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	private var vocals:FlxSound;

	override function create()
	{
		FlxG.game.scaleX = 1;
		FlxG.game.x = 0;
		FlxG.game.scaleY = 1;
		FlxG.game.y = 0;

		var initSocials:Array<String> = [
			"0:twitter://twitter.com/blitz_crystal:0",
			"0:youtube://youtube.com/channel/UCMadZ48_jeieJdC72WO7x4w:1",
			"1:twitter://twitter.com/Fpeyro:0",
			"2:twitter://twitter.com/elikapika:0",
			"3:twitter://twitter.com/tamacoochi:0",
			"4:twitter://twitter.com/xkem0x:0",
			"4:portfolio://kemo.dev:1",
			"5:twitter://twitter.com/GWebDevFNF:0",
			"6:twitter://twitter.com/bee_hanii:0",
			"7:twitter://twitter.com/staromelobean:0",
			"7:youtube://youtube.com/channel/UC7GYd5L0m-Z_mJAi_RNaM7Q:1",
			"8:twitter://twitter.com/AlchoholicDj:0"
        ];

		for (i in 0...initSocials.length)
		{
			var data:Array<String> = initSocials[i].split(':');
			socialCatagory.push(Std.parseInt(data[0]));
			socialNames.push(data[1]);
			socialLink.push(data[2]);
			dumbPersonArray.push(Std.parseInt(data[3]));
		}
		
		trace(socialCatagory);
		trace(socialNames);

		songs = [
			"Crystal",
			"Peyro",
			"Elika",
			"Tama",
			"Kemo",
			"GWebDev",
			"Hani Bee",
			"Staromelo",
			"D.J"
		];

		icons = [
			'crystal',
			'peyro',
			'elika',
			'tama',
			'kemo',
			'gweb',
			'bee',
			'staromelo',
			'dj'
		];

		titles = [
			'Creator',
            'Composer',
            'Artist',
			'Icons art',
			'Main coder',
			'Demo coder',
			'Cutscene art',
            'BG art',
			'Charter'
		];

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		bg.alpha = 0;


		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		//add(checker);
		//checker.scrollFactor.set(0, 0.07);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		grpTitles = new FlxTypedGroup<Alphabet>();
		add(grpTitles);

		grpSocials = new FlxTypedGroup<Alphabet>();
		add(grpSocials);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.itemType = "Diagonal";
			songText.targetY = i;
			grpSongs.add(songText);

			var daIcon = new HealthIcon(icons[i]);
			daIcon.sprTracker = songText;
			add(daIcon);

			songText.sprTracker = daIcon;

			realLength++;
		}

		for (i in 0...titles.length)
		{
			var songText:Alphabet = new Alphabet(20, 10, titles[i], true, false);
			songText.scale.set(1.3, 1.3);
			songText.y += 20;
			songText.screenCenter(X);
			songText.visible = false;
			grpTitles.add(songText);
		}

		for (i in 0...socialNames.length)
		{
			trace(dumbPersonArray[i]);
			var songText:Alphabet = new Alphabet(0, (70 * dumbPersonArray[i]) + 50, socialNames[i], true, false);
			songText.x += 500;
			songText.itemType = "CVertical";
			songText.targetY = dumbPersonArray[i];
			grpSocials.add(songText);
			
		}
		changeSelection();


		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();

		FlxTween.tween(bg, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});
		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom:1, alpha:1}, 0.5, { ease: FlxEase.quartInOut});

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				selectable = true;
			});
	}

	var selectedSomethin:Bool = false;
	var selectable:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		persistentUpdate = persistentDraw = true;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (!selectedSomethin && selectable)
		{
			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

			if (controls.BACK)
			{
				if (inCat) {
					exitCat();
				} else {
				FlxG.switchState(new MainMenuState());
				selectedSomethin = true;
				FlxTween.tween(FlxG.camera, { zoom:0.6, alpha:-0.6}, 0.7, { ease: FlxEase.quartInOut});
				FlxTween.tween(bg, { alpha:0}, 0.7, { ease: FlxEase.quartInOut});
				//FlxTween.tween(checker, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(gradientBar, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});

				#if windows
						DiscordClient.changePresence("Going back!", null);
				#end

				FlxG.sound.play(Paths.sound('cancelMenu'), 1);
				}
			}

			if (accepted)
			{
				if (!inCat) {
					enterCat();
				} else {
				#if linux
				Sys.command('/usr/bin/xdg-open', 'https:' + socialLink[grpSocials.members.indexOf(lazyShit)], "&"]);
				#else
				FlxG.openURL('https:' + socialLink[grpSocials.members.indexOf(lazyShit)]);
				#end
				}
			}
		}
	}

	function enterCat() {
		curSelectedInCat = 0;
		catLength = 0;
		for (i in grpSocials) {
			i.alpha = 1;
			if (i.visible) {
				catLength++;
			}
		}
		inCat = true;
		changeSelection();
	}

	function exitCat() {
		inCat = false;
		changeSelection();
	}

	function changeSelection(change:Int = 0)
	{

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		if (inCat) {
			curSelectedInCat += change;

			if (curSelectedInCat < 0)
				curSelectedInCat = catLength - 1;
			if (curSelectedInCat >= catLength)
				curSelectedInCat = 0;
		} else {
			curSelected += change;

			if (curSelected < 0)
				curSelected = realLength - 1;
			if (curSelected >= realLength)
				curSelected = 0;
		}

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			item.sprTracker.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				item.sprTracker.alpha = 1.0;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		if (inCat) 
			{
			//i am again sorry for being dumb
			var dumbArray:Array<Alphabet> = [];
			for (i in grpSocials) {
				if (socialCatagory[grpSocials.members.indexOf(i)] == curSelected) {
					dumbArray.push(i);
				}
			}
			for (i in dumbArray) {
				if (dumbArray.indexOf(i) == curSelectedInCat) {
					i.alpha = 1;
					lazyShit = i;
				} else {
					i.alpha = 0.6;
				}
			}
		} else {
			for (i in grpSocials) {
				i.alpha = 0;
			}
		}
		for (i in grpTitles.members) {
			if (grpTitles.members.indexOf(i) == curSelected) {
				i.visible = true;
			} else {
				i.visible = false;
			}
		}

		for (i in 0...grpSocials.members.length) {
			if (socialCatagory[i] == curSelected) {
				grpSocials.members[i].visible = true;
			} else {
				grpSocials.members[i].visible = false;
			}
		}


		#if windows
		// Updating Discord Rich Presence
		switch (FlxG.random.int(0, 5))
		{
			case 0:
				DiscordClient.changePresence("Vibing to " + songs[curSelected] + " for:", null, null, true);
			case 1:
				DiscordClient.changePresence("Sleeping on someone with " + songs[curSelected] + " for:", null, null, true);
			case 2:
				DiscordClient.changePresence("Dreaming about " + songs[curSelected] + " for:", null, null, true);
			case 3:
				DiscordClient.changePresence("Suckling some " + songs[curSelected] + " for:", null, null, true);
			case 4:
				DiscordClient.changePresence("Presenting " + songs[curSelected] + " to myself for:", null, null, true);
			case 5:
					DiscordClient.changePresence("Admiring " + songs[curSelected] + " for:", null, null, true);
		}
		#end
	}
}