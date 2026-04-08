package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var _versionText:FlxText;

	override public function create()
	{
		super.create();

		_versionText = new FlxText(0, 0, 0, FlxG.stage.application.meta.get('version'), 16);
		add(_versionText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
