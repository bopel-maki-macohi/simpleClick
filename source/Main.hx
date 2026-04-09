package;

import modding.PolymodHandler;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Save.instance = new Save();
		Save.instance.init();

		#if FEATURE_MODDING
		PolymodHandler.loadEnabledMods();
		#end

		addChild(new FlxGame(0, 0, PlayState));
	}
}
