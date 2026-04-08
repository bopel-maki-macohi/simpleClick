package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var _versionText:FlxText;

	public var _object:FlxSprite;

	public var _score:Int = 0;
	public var _scoreText:FlxText;

	override public function create()
	{
		super.create();

		_versionText = new FlxText(0, 0, 0, FlxG.stage.application.meta.get('version'), 16);
		add(_versionText);

		_object = new FlxSprite();
		_object.makeGraphic(64, 64, FlxColor.RED);
		_object.screenCenter();
		add(_object);

		_scoreText = new FlxText(0, 10, 0, '', 16);
		_scoreText.alignment = CENTER;
		add(_scoreText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		_scoreText.text = 'SCORE:\n' + _score; 
		_scoreText.screenCenter(X);

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_object))
			onClick();
	}

	function onClick() {}
}
