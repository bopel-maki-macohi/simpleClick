import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import modding.events.ScriptEvent.ObjectScriptEvent;
import modding.modules.Module;

class ScoreIncrementPopup extends Module
{
	override public function new()
	{
		super('score-increment-popup');
	}

	override function onPostObjectClick(event:ObjectScriptEvent)
	{
		super.onPostObjectClick(event);

		var popup:FlxText = new FlxText(0, 0, 0, '+ ${event.increment}', 32);

		popup.setFormat(null, 16, FlxColor.LIME, CENTER, OUTLINE, FlxColor.WHITE);
		popup.screenCenter();

		PlayState.instance.add(popup);

		FlxTween.tween(popup, {alpha: 0}, 1,
			{
				ease: FlxEase.sineInOut,
				onComplete: t -> {
					PlayState.instance.remove(popup);
					popup.destroy();
				}
			});
	}
}
