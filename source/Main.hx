package;

import plugins.ReloadAssetsDebugPlugin;
import flixel.FlxG;
import modding.modules.ModuleHandler;
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

		ModuleHandler.buildModuleCallbacks();

		#if FEATURE_MODDING
		PolymodHandler.forceReloadAssets();
		#end

		ReloadAssetsDebugPlugin.initialize();

		addChild(new FlxGame(0, 0, PlayState));
	}
}
