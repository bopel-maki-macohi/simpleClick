package simpleclick.objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class ScoreIncrementPopup extends FlxText
{
	override public function new(increment:Int, newHighscore:Bool)
	{
		super(0, 0, 0, '+ ${increment}', 32);

		if (increment < 0) text = '- ${Math.abs(increment)}';

		setFormat(null, 16, FlxColor.WHITE, 'center');
		screenCenter();
		y = (PlayState.instance._scoreText.y + PlayState.instance._scoreText.height) + (height * 0.25);
	}

	public static function build(increment:Int, newHighscore:Bool)
	{
		var popup:ScoreIncrementPopup = new ScoreIncrementPopup(increment, newHighscore);

		PlayState.instance.add(popup);

		if (newHighscore)
		{
			FlxTween.cancelTweensOf(PlayState.instance._scoreText);

			PlayState.instance._scoreText.color = FlxColor.LIME;
			FlxTween.color(PlayState.instance._scoreText, 0.2, PlayState.instance._scoreText.color, FlxColor.WHITE,
				{
					ease: FlxEase.sineInOut
				});

			FlxTween.color(popup, 0.2, FlxColor.LIME, FlxColor.WHITE,
				{
					ease: FlxEase.sineInOut
				});
		}

		FlxTween.tween(popup, {alpha: 0, y: -popup.height * 4}, 1,
			{
				ease: FlxEase.backInOut,
				onComplete: t -> {
					PlayState.instance.remove(popup);
					popup.destroy();
				}
			});
	}
}
