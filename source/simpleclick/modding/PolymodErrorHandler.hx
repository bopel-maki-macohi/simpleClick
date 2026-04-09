package simpleclick.modding;

import flixel.FlxG;
import polymod.Polymod;

class PolymodErrorHandler
{
	public static function onError(e:PolymodError)
	{
		var idontcare = [
			FRAMEWORK_INIT,
			MOD_MISSING_ICON,
			// MOD_LOAD_START,
			// MOD_LOAD_DONE,
			// SCRIPT_PARSE_START
		];

		if (idontcare.contains(e.code)) return;
		if (e.message.startsWith('Registering scripted class ')) return;

		trace(Std.string(e.code ?? 'DEBUG').toUpperCase() + ' : ' + e.message);

		if (e.severity == ERROR || e.code == MOD_DEPENDENCY_UNMET) FlxG.stage.application.window.alert(e.message);
	}
}
