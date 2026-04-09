package scripting;

import haxe.ds.StringMap;
import scripting.ScriptBases;

class ModuleHandler
{
	public static var modules:StringMap<Module> = new StringMap<Module>();

	public static function clear()
	{
		for (id => module in modules)
		{
			modules.remove(id);
		}
	}

	public static function load()
	{
		clear();

		var scripts:Array<String> = ScriptedModule.listScriptClasses();

		trace('Loading ${scripts.length} scripted module(s)...');

		for (script in scripts)
		{
			try
			{
				var module:Module = ScriptedModule.scriptInit(script, '');
				modules.set(script, module);
			}
			catch (e)
				trace('Failed to load script $script.');
		}
	}
}
