import modding.PolymodHandler;
import flixel.FlxG;
import modding.modules.ModuleHandler;
import modding.events.ScriptEvent;
import flixel.FlxState;

class BaseState extends FlxState
{
	public function dispatch(event:ScriptEvent)
		ModuleHandler.callEvent(event);

	public function reloadAssets()
	{
		PolymodHandler.forceReloadAssets();

		// Restart the current state, so old data is cleared.
		FlxG.resetState();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		dispatch(new UpdateScriptEvent(elapsed));
	}
}
