package modding.events;

import modding.IScriptedClass;
import modding.modules.Module;

@:nullSafety
class ScriptEventDispatcher
{
	public static function callEvent(target:Null<IScriptedClass>, event:ScriptEvent):Void
	{
		if (target == null || event == null) return;

		target.onScriptEvent(event);

		// If one target says to stop propagation, stop.
		if (!event.shouldPropagate)
		{
			return;
		}

		// IScriptedClass
		switch (event.type)
		{
			case CREATE:
				target.onCreate(event);
				return;
			case DESTROY:
				target.onDestroy(event);
				return;
			case UPDATE:
				target.onUpdate(cast event);
				return;
			default: // Continue;
		}

		// If we reach this line, it means a script event was dispatched while not being properly handled.
		// Throw an error so we know to add additional fallbacks.
		throw 'No corresponding function called for dispatched event type: ${event.type}';
	}

	public static function callEventOnAllTargets(targets:Iterator<IScriptedClass>, event:ScriptEvent):Void
	{
		if (targets == null || event == null) return;

		if (Std.isOfType(targets, Array))
		{
			var t = cast(targets, Array<Dynamic>);
			if (t.length == 0) return;
		}

		for (target in targets)
		{
			var t:IScriptedClass = cast target;
			if (t == null) continue;

			callEvent(t, event);

			// If one target says to stop propagation, stop.
			if (!event.shouldPropagate)
			{
				return;
			}
		}
	}
}
