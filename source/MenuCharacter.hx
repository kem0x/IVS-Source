package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'crystal' => new CharacterSetting(),
		'kuna' => new CharacterSetting(),
		'bao' => new CharacterSetting(),
	];

	private var flipped:Bool = false;
	// questionable variable name lmfao
	private var goesLeftNRight:Bool = false;
	private var danceLeft:Bool = false;
	public var character:String = '';

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = FlxG.save.data.antialiasing;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('crystal', '01idle', 24);
		animation.addByPrefix('bao', '1idel', 24);
		animation.addByPrefix('kuna', 'GF Dancing Beat copy', 24);

		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		var sameCharacter:Bool = character == this.character;
		this.character = character;
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		if (!sameCharacter)
		{
			bopHead(true);
		}

		/*var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;*/
	}

	public function bopHead(LastFrame:Bool = false):Void
	{
		if (character == 'gf' || character == 'spooky')
		{
			danceLeft = !danceLeft;

			if (danceLeft)
				animation.play(character + "-left", true);
			else
				animation.play(character + "-right", true);
		}
		else if (character == '')
		{
			// Don't try to play an animation on an invisible character.
			return;
		}
		else
		{
			// no spooky nor girlfriend so we do da normal animation
			if (animation.name == "bfConfirm")
				return;
			animation.play(character, true);
		}
		if (LastFrame)
		{
			animation.finish();
		}
	}
}
