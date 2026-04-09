package modding.events;

import modding.IScriptedClass;

@:nullSafety
class ScriptEventDispatcher
{
	public static function callEvent(target:Null<IScriptedClass>, event:ScriptEvent):Void
	{
		if (target == null || event == null) return;

		target.onScriptEvent(event);

		// If one target says to stop propagation, stop.
		if (!event.shouldPropagate) return;

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

		if (Std.isOfType(target, IStageChangingScriptedClass))
		{
			var newTarget:IStageChangingScriptedClass = cast(target, IStageChangingScriptedClass);

			if (newTarget == null) return;

			switch (event.type)
			{
				case STATE_CHANGE_BEGIN:
					newTarget.onStateChangeBegin(cast event);
					return;
				case STATE_CHANGE_END:
					newTarget.onStateChangeEnd(cast event);
					return;

				default:
			}
		}
		else
		{
			// If the target doesn't support the event, stop trying to dispatch.
			if ([ScriptEventType.STATE_CHANGE_BEGIN, ScriptEventType.STATE_CHANGE_END].contains(event.type)) return;
		}

		if (Std.isOfType(target, IObjectScriptedClass))
		{
			var newTarget:IObjectScriptedClass = cast(target, IObjectScriptedClass);

			if (newTarget == null) return;

			switch (event.type)
			{
				case OBJECT_CLICK_PRE:
					newTarget.onPreObjectClick(cast event);
					return;
				case OBJECT_CLICK_POST:
					newTarget.onPostObjectClick(cast event);
					return;

				default:
			}
		}
		else
		{
			// If the target doesn't support the event, stop trying to dispatch.
			if ([ScriptEventType.OBJECT_CLICK_PRE, ScriptEventType.OBJECT_CLICK_POST].contains(event.type)) return;
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
