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

		FlxG.switchState(() -> new PlayState());
	}
}
