import simpleclick.PlayState;
import simpleclick.modding.enumhandling.FlxOutlineText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import simpleclick.modding.events.ScriptEvent;
import simpleclick.modding.modules.Module;

class ScoreIncrementPopup extends Module
{
	override public function new()
	{
		super('score-increment-popup');
	}

	override function onPostObjectClick(event:ObjectScriptEvent)
	{
		super.onPostObjectClick(event);

		if (PlayState.instance == null) return;

		var popup:FlxOutlineText = new FlxOutlineText(0, 0, 0, '+ ${event.increment}', 32);

		popup.setFormat(null, 16, FlxColor.WHITE, 'center');
		popup.screenCenter();
		popup.y = (PlayState.instance._scoreText.y + PlayState.instance._scoreText.height) + (popup.height * 0.25);

		PlayState.instance.add(popup);

		if (event.highscore)
		{
			scoreTextHighscore();
			popupTextHighscore(popup);
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

	function scoreTextHighscore()
	{
		FlxTween.cancelTweensOf(PlayState.instance._scoreText);

		PlayState.instance._scoreText.color = FlxColor.LIME;
		FlxTween.color(PlayState.instance._scoreText, 0.2, PlayState.instance._scoreText.color, FlxColor.WHITE,
			{
				ease: FlxEase.sineInOut
			});
	}

	function popupTextHighscore(popup:FlxText)
	{
		FlxTween.color(popup, 0.2, FlxColor.LIME, FlxColor.WHITE,
			{
				ease: FlxEase.sineInOut
			});
	}
}
