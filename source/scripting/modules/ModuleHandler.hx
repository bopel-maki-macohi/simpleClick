package scripting.modules;

import scripting.events.ScriptEvent;
import scripting.events.*;
import scripting.ScriptBases;
import flixel.FlxG;
import haxe.ds.StringMap;

/**
 * A class for handling the engine's modules.
 */
class ModuleHandler
{
	static var modules(default, null) = new StringMap<Module>();

	public static function load()
	{
		clear();

		// Loads the modules
		var scripts:Array<String> = ScriptedModule.listScriptClasses();

		for (script in scripts)
		{
			try
			{
				var module:Module = ScriptedModule.scriptInit(script, '');
				modules.set(module.id, module);
			}
			catch (e)
				trace('Failed to load script $script.');
		}

		dispatch(new ScriptEvent(Create));

		FlxG.signals.postUpdate.add(update);

		trace('Done loading modules.');
	}

	public static function getModule(id:String):Module
		return modules.get(id);

	public static function setModuleActive(id:String, active:Bool)
	{
		var module:Module = getModule(id);
		if (module != null) module.active = active;
	}

	public static function dispatch(event:ScriptEvent)
	{
		for (module in modules)
		{
			if (!module.active) continue;

			ScriptEventDispatcher.dispatch(module, event);
		}
	}

	static function update()
	{
		for (module in modules)
		{
			if (!module.active) continue;

			ScriptEventDispatcher.dispatch(module, new UpdateScriptEvent(FlxG.elapsed));
		}
	}

	static function clear()
	{
		for (module in modules)
		{
			var event:ScriptEvent = new ScriptEvent(Destroy);
			ScriptEventDispatcher.dispatch(module, event);
		}

		modules.clear();

		FlxG.signals.postUpdate.remove(update);
	}
}
