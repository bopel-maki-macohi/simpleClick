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

		var popup:FlxOutlineText = new FlxOutlineText(0, 0, 0, '+ ${event.increment}', 32);

		popup.setFormat(null, 16, FlxColor.WHITE, 'center');
		// popup.setBorderStyle(popup.borderStyle, FlxColor.WHITE, 4);
		popup.screenCenter();
		popup.y = (PlayState.instance._scoreText.y + PlayState.instance._scoreText.height) + (popup.height * 0.25);

		PlayState.instance.add(popup);

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
