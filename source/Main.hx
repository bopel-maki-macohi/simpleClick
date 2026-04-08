package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Save.instance = new Save();
		Save.instance.init();

		addChild(new FlxGame(0, 0, PlayState));
	}
}
