import flixel.FlxState;
import simpleclick.plugins.ReloadAssetsDebugPlugin;
import flixel.FlxG;
import simpleclick.modding.modules.ModuleHandler;
import simpleclick.modding.PolymodHandler;
import simpleclick.*;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		Save.instance = new Save();
		Save.instance.init();

		ModuleHandler.buildModuleCallbacks();

		PolymodHandler.forceReloadAssets();

		ReloadAssetsDebugPlugin.initialize();

		FlxG.switchState(() -> new PlayState());
	}
}
