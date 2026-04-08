package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Save._instance = new Save();

		addChild(new FlxGame(0, 0, PlayState));
	}
}
