import lime.utils.Assets;
import haxe.Json;
import flixel.FlxState;
import flixel.FlxG;
import simpleclick.*;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		Save.instance = new Save();
		Save.instance.init();

		ChangelogState.changelog = Json.parse(Assets.getText('assets/data/CHANGELOG.json'));

		FlxG.switchState(() -> new PlayState());
	}
}
