package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
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

	public static var score:Int = 0;

	public var _highscore:Int = 0;
	public var _scoreText:FlxText;

	override public function create()
	{
		super.create();

		ModState.currentSelection = 0;

		ChangelogState.changelog = Json.parse(Assets.getText('assets/data/CHANGELOG.json'));

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
		if (FlxG.keys.justReleased.M) FlxG.switchState(() -> new ModState());
	}

	function onClick()
	{
		PlayState.score += 1;

		if (PlayState.score > Save.instance.highscore.get()) Save.instance.highscore.set(PlayState.score);

		_object.scale.set(0.9, 0.9);

		FlxTween.cancelTweensOf(_object);
		FlxTween.tween(_object, {'scale.x': 1, 'scale.y': 1}, .2,
			{
				ease: FlxEase.sineOut
			});
	}
}
