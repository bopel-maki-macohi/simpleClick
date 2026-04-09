package simpleclick.plugins;

import simpleclick.modding.PolymodHandler;
import flixel.FlxG;
import flixel.FlxBasic;

/**
 * A plugin which adds functionality to press `F5` to reload all game assets, then reload the current state.
 * This is useful for hot reloading assets during development.
 */
@:nullSafety
class ReloadAssetsDebugPlugin extends FlxBasic
{
	public function new()
	{
		super();
	}

	public static function initialize():Void
	{
		FlxG.plugins.addPlugin(new ReloadAssetsDebugPlugin());
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if html5
		if (FlxG.keys.justPressed.FIVE && FlxG.keys.pressed.SHIFT)
		#else
		if (FlxG.keys.justPressed.F5)
		#end
		{
			reload();
		}
	}

	public override function destroy():Void
	{
		super.destroy();
	}

	var path:String = "";

	function reload():Void
	{
		var state:Dynamic = FlxG.state;
		var isScripted:Bool = false;
		// var isScripted:Bool = state is ScriptedMusicBeatState;
		// if (isScripted)
		// {
		// 	var s:ScriptedMusicBeatState = cast FlxG.state;
		// 	@:privateAccess
		// 	path = s._asc.fullyQualifiedName;
		// 	trace("Current scripted state path: " + path);
		// }

		if ((state is BaseState) && !isScripted) state.reloadAssets();
		else
		{
			PolymodHandler.forceReloadAssets();

			trace("Reloaded assets, checking for scripted state. Scripted: " + isScripted + ", Path: " + path);
			// if (isScripted)
			// {
			// 	trace("Reloading scripted state: " + path);
			// 	var state:Dynamic = ScriptedMusicBeatState.scriptInit(path);
			// 	FlxG.switchState(state);
			// }

			// Create a new instance of the current state, so old data is cleared.
			if (!isScripted) FlxG.resetState();
		}
	}
}
