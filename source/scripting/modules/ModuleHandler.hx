package scripting.modules;

class ModuleHandler
{
	public static var modules:Map<String, Module> = [];

	public static function clear() {}

	public static function load()
	{
		clear();

        if (ModCore.modFileSystem == null) return;

        var modules:Array<String> = ModCore.modFileSystem.readDirectory('assets/scripting/modules');

        for (module in modules)
        {
            trace(modules);
        }
	}
}
