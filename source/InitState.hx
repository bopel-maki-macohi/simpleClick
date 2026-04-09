import flixel.FlxState;
import plugins.ReloadAssetsDebugPlugin;
import flixel.FlxG;
import modding.modules.ModuleHandler;
import modding.PolymodHandler;

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
