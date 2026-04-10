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

	override function onPostObjectClick(event:ObjectScriptEvent):ObjectScriptEvent
	{
		if (PlayState.instance == null) return event;

		var popup:FlxOutlineText = new FlxOutlineText(0, 0, 0, '+ ${event.increment}', 32);

		if (event.increment < 0) popup.text = '- ${Math.abs(event.increment)}';

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

		return super.onPostObjectClick(event);
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
