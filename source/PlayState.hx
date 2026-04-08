package;

import lime.utils.Assets;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var _versionText:FlxText;

	public var _object:FlxSprite;

	public static var score:MInt = 0;
	public var _highscore:MInt = 0;
	public var _scoreText:FlxText;

	override public function create()
	{
		super.create();

		ChangelogState.changelog = Json.parse(Assets.getText('assets/CHANGELOG.json'));

		_versionText = new FlxText(0, 0, 0, FlxG.stage.application.meta.get('version'), 16);
		add(_versionText);

		_object = new FlxSprite();
		_object.makeGraphic(64, 64, FlxColor.RED);
		_object.screenCenter();
		add(_object);

		_scoreText = new FlxText(0, 10, 0, '', 16);
		_scoreText.alignment = CENTER;
		add(_scoreText);

		_highscore = Save.instance.highscore.get();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		_scoreText.text = 'SCORE: ${PlayState.score}\n' + 'HIGHSCORE: ${Save.instance.highscore}';
		_scoreText.screenCenter(X);

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_object)) onClick();
		if (FlxG.keys.justReleased.C) FlxG.switchState(() -> new ChangelogState());
	}

	function onClick()
	{
		PlayState.score += 1;

		if (PlayState.score > Save.instance.highscore.get()) Save.instance.highscore.set(PlayState.score);
	}
}
