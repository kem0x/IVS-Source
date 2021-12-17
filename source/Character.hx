package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var barColor:FlxColor;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		barColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		switch (curCharacter)
		{
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByIndices('idleLoop', "Dad idle dance", [11, 12], "", 12, true);

				loadOffsetFile(curCharacter);
				barColor = 0xFFaf66ce;

				playAnim('idle');

			case 'kuna':
				tex = Paths.getSparrowAtlas('kuna', 'shared', true);
				frames = tex;
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -2, -20);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, -4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -28);

				playAnim('danceRight');

			case 'kuna-nospeakers':
				tex = Paths.getSparrowAtlas('kuna_none', 'shared', true);
				frames = tex;
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -69, -25);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", -65, -18);
				addOffset("singRIGHT", -74, -20);
				addOffset("singLEFT", -53, -20);
				addOffset("singDOWN", -66, -25);

				playAnim('danceRight');

			case 'bao':
				tex = Paths.getSparrowAtlas('bao', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', '1idel', 18, false);
				animation.addByPrefix('singUP', '4up', 18, false);
				animation.addByPrefix('singRIGHT', '2right', 14, false);
				animation.addByPrefix('singDOWN', '5down', 14, false);
				animation.addByPrefix('singLEFT', '3left0', 14, false);
				animation.addByPrefix('go', 'lesgolesbians', 18, false);

				loadOffsetFile(curCharacter);
				barColor = 0xFF619ad3;

				playAnim('idle');

			case 'shark':
				tex = Paths.getSparrowAtlas('shark', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', '1_idle', 24, false);
				animation.addByPrefix('singUP', '2_up', 24, false);
				animation.addByPrefix('singRIGHT', '4_right', 24, false);
				animation.addByPrefix('singDOWN', '5_down', 24, false);
				animation.addByPrefix('singLEFT', '3_left', 24, false);
				animation.addByPrefix('bite', '6bite', 24, false);
				animation.addByPrefix('scream', '10yell', 24, false);
				animation.addByPrefix('crash', '9crash', 24, false);

				loadOffsetFile(curCharacter);
				barColor = 0xFF619ad3;

				playAnim('idle');

			case 'domo':
				tex = Paths.getSparrowAtlas('domo', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', '1idle', 24, false);
				animation.addByPrefix('singUP', '2up', 24, false);
				animation.addByPrefix('singRIGHT', '4right', 24, false);
				animation.addByPrefix('singDOWN', '3down', 24, false);
				animation.addByPrefix('singLEFT', '5left', 24, false);
				animation.addByPrefix('rude', 'RUDE', 24, false);

				loadOffsetFile(curCharacter);
				barColor = 0xFF619ad3;

				playAnim('idle');
			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND', 'shared', true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				barColor = 0xFF31b0d1;

				flipX = true;

			case 'crystal':
				var tex = Paths.getSparrowAtlas('crystal', 'shared', true);
				frames = tex;

				animation.addByPrefix('idle', '01idle0', 24, false);

				animation.addByPrefix('singUP', '04up0', 24, false);
				animation.addByPrefix('singLEFT', '03left0', 24, false);
				animation.addByPrefix('singRIGHT', '02right0', 24, false);
				animation.addByPrefix('singDOWN', '05down0', 24, false);
				animation.addByPrefix('singUPmiss', '04upmiss', 24, false);
				animation.addByPrefix('singLEFTmiss', '03leftmiss', 24, false);
				animation.addByPrefix('singRIGHTmiss', '02rightmiss', 24, false);
				animation.addByPrefix('singDOWNmiss', '05downmiss', 24, false);

				animation.addByPrefix('firstDeath', "00dying", 24, false);
				animation.addByPrefix('deathLoop', "00ded", 24, false);
				animation.addByPrefix('deathConfirm', "11confirm", 24, false);

				// loadOffsetFile(curCharacter);

				addOffset('idle');
				addOffset("singUP", -30, 12);
				addOffset("singRIGHT", -51, 3);
				addOffset("singLEFT", -6, 0);
				addOffset("singDOWN", -28, -14);
				addOffset("singUPmiss", -30, 12);
				addOffset("singRIGHTmiss", -51, 3);
				addOffset("singLEFTmiss", -6, 0);
				addOffset("singDOWNmiss", -28, -14);
				addOffset("firstDeath", 52, 11);
				addOffset("deathLoop", 53, 16);
				addOffset("deathConfirm", 33, -227);

				playAnim('idle');

				barColor = 0xFFccffff;

				flipX = true;

			case 'crystal-nervy':
				var tex = Paths.getSparrowAtlas('crystal', 'shared', true);
				frames = tex;

				animation.addByPrefix('idle', '01idlenervy', 24, false);
				animation.addByPrefix('singUP', '04upnerv', 24, false);
				animation.addByPrefix('singLEFT', '03leftnerv', 24, false);
				animation.addByPrefix('singRIGHT', '02rightnerv', 24, false);
				animation.addByPrefix('singDOWN', '05downnervy', 24, false);
				animation.addByPrefix('singUPmiss', '04upmiss', 24, false);
				animation.addByPrefix('singLEFTmiss', '03leftmiss', 24, false);
				animation.addByPrefix('singRIGHTmiss', '02rightmiss', 24, false);
				animation.addByPrefix('singDOWNmiss', '05downmiss', 24, false);

				animation.addByPrefix('firstDeath', "00dying", 24, false);
				animation.addByPrefix('deathLoop', "00ded", 24, false);
				animation.addByPrefix('deathConfirm', "11confirm", 24, false);

				addOffset('idle');
				addOffset("singUP", -30, 12);
				addOffset("singRIGHT", -51, 3);
				addOffset("singLEFT", -6, 0);
				addOffset("singDOWN", -28, -14);
				addOffset("singUPmiss", -30, 12);
				addOffset("singRIGHTmiss", -51, 3);
				addOffset("singLEFTmiss", -6, 0);
				addOffset("singDOWNmiss", -28, -14);
				addOffset("firstDeath", 52, 11);
				addOffset("deathLoop", 53, 16);
				addOffset("deathConfirm", 33, -227);

				playAnim('idle');

				barColor = 0xFFccffff;

				flipX = true;

			default:
				parseDataFile();
		}

		if (curCharacter.startsWith('bf') || curCharacter.startsWith('crystal'))
			dance();

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf') || !curCharacter.startsWith('crystal'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function parseDataFile()
	{
		Debug.logInfo('Generating character (${curCharacter}) from JSON data...');

		// Load the data from JSON and cast it to a struct we can easily read.
		var jsonData = Paths.loadJSON('characters/${curCharacter}');
		if (jsonData == null)
		{
			Debug.logError('Failed to parse JSON data for character ${curCharacter}');
			return;
		}

		var data:CharacterData = cast jsonData;

		var tex:FlxAtlasFrames = Paths.getSparrowAtlas(data.asset, 'shared');
		frames = tex;
		if (frames != null)
			for (anim in data.animations)
			{
				var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
				var looped = anim.looped == null ? false : anim.looped;
				var flipX = anim.flipX == null ? false : anim.flipX;
				var flipY = anim.flipY == null ? false : anim.flipY;

				if (anim.frameIndices != null)
				{
					animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped, flipX, flipY);
				}
				else
				{
					animation.addByPrefix(anim.name, anim.prefix, frameRate, looped, flipX, flipY);
				}

				animOffsets[anim.name] = anim.offsets == null ? [0, 0] : anim.offsets;
			}

		barColor = FlxColor.fromString(data.barColor);

		playAnim(data.startingAnim);
	}

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			if (curCharacter.endsWith('-car')
				&& !animation.curAnim.name.startsWith('sing')
				&& animation.curAnim.finished
				&& animation.getByName('idleHair') != null)
				playAnim('idleHair');

			if (animation.getByName('idleLoop') != null)
			{
				if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
					playAnim('idleLoop');
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			else if (curCharacter == 'gf' || curCharacter.startsWith("kuna") || curCharacter == 'spooky')
				dadVar = 4.1; // fix double dances
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				if (curCharacter == 'gf' || curCharacter.startsWith("kuna") || curCharacter == 'spooky')
					playAnim('danceLeft'); // overridden by dance correctly later
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf' | 'kuna' | 'kuna-nospeakers':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
				{
					danced = true;
					playAnim('danceRight');
				}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false, altAnim:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'kuna' | 'kuna-nospeakers':
					if (!animation.curAnim.name.startsWith('hair') && !animation.curAnim.name.startsWith('sing'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					if (!animation.curAnim.name.startsWith('sing'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				/*
					// new dance code is gonna end up cutting off animation with the idle
					// so here's example code that'll fix it. just adjust it to ya character 'n shit
					case 'custom character':
						if (!animation.curAnim.name.endsWith('custom animation'))
							playAnim('idle', forced);
				 */
				default:
					if (altAnim && animation.getByName('idle-alt') != null)
						playAnim('idle-alt', forced);
					else
						playAnim('idle', forced);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0, Force2:Bool = false):Void
	{
		if (animation.curAnim != null
			&& (animation.curAnim.name.startsWith("bite")
				|| animation.curAnim.name.startsWith("go")
				|| animation.curAnim.name.startsWith("scream")
				|| animation.curAnim.name.startsWith("rude"))
			&& !Force2)
		{
			return;
		}

		if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
		{
			#if debug
			FlxG.log.warn(['Such alt animation doesnt exist: ' + AnimName]);
			#end
			AnimName = AnimName.split('-')[0];
		}

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf' || curCharacter.startsWith('kuna'))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

typedef CharacterData =
{
	var name:String;
	var asset:String;
	var startingAnim:String;

	/**
	 * The color of this character's health bar.
	 */
	var barColor:String;

	var animations:Array<AnimationData>;
}

typedef AnimationData =
{
	var name:String;
	var prefix:String;
	var ?offsets:Array<Int>;

	/**
	 * Whether this animation is looped.
	 * @default false
	 */
	var ?looped:Bool;

	var ?flipX:Bool;
	var ?flipY:Bool;

	/**
	 * The frame rate of this animation.
	 		* @default 24
	 */
	var ?frameRate:Int;

	var ?frameIndices:Array<Int>;
}
