package simpleclick.modding.events;

import simpleclick.modding.IScriptedClass;

@:nullSafety
class ScriptEventDispatcher
{
	public static function callEvent(target:Null<IScriptedClass>, event:ScriptEvent):ScriptEvent
	{
		if (target == null || event == null) return event;

		event = target.onScriptEvent(event);

		// If one target says to stop propagation, stop.
		if (!event.shouldPropagate) return event;

		// IScriptedClass
		switch (event.type)
		{
			case CREATE:
				return target.onCreate(event);
			case DESTROY:
				return target.onDestroy(event);
			case UPDATE:
				return target.onUpdate(cast event);
			default: // Continue;
		}

		if (Std.isOfType(target, IStageChangingScriptedClass))
		{
			var newTarget:IStageChangingScriptedClass = cast(target, IStageChangingScriptedClass);

			if (newTarget == null) return event;

			switch (event.type)
			{
				case STATE_CHANGE_BEGIN:
					return newTarget.onStateChangeBegin(cast event);
				case STATE_CHANGE_END:
					return newTarget.onStateChangeEnd(cast event);

				default:
			}
		}
		else
		{
			// If the target doesn't support the event, stop trying to dispatch.
			if ([ScriptEventType.STATE_CHANGE_BEGIN, ScriptEventType.STATE_CHANGE_END].contains(event.type)) return event;
		}

		if (Std.isOfType(target, IObjectScriptedClass))
		{
			var newTarget:IObjectScriptedClass = cast(target, IObjectScriptedClass);

			if (newTarget == null) return event;

			switch (event.type)
			{
				case OBJECT_CLICK_PRE:
					return newTarget.onPreObjectClick(cast event);
				case OBJECT_CLICK_POST:
					return newTarget.onPostObjectClick(cast event);

				default:
			}
		}
		else
		{
			// If the target doesn't support the event, stop trying to dispatch.
			if ([ScriptEventType.OBJECT_CLICK_PRE, ScriptEventType.OBJECT_CLICK_POST].contains(event.type)) return event;
		}

		// If we reach this line, it means a script event was dispatched while not being properly handled.
		// Throw an error so we know to add additional fallbacks.
		throw 'No corresponding function called for dispatched event type: ${event.type}';
	}

	public static function callEventOnAllTargets(targets:Iterator<IScriptedClass>, event:ScriptEvent):ScriptEvent
	{
		if (targets == null || event == null) return event;

		if (Std.isOfType(targets, Array))
		{
			var t = cast(targets, Array<Dynamic>);
			if (t.length == 0) return event;
		}

		for (target in targets)
		{
			var t:IScriptedClass = cast target;
			if (t == null) continue;

			event = callEvent(t, event);

			// If one target says to stop propagation, stop.
			if (!event.shouldPropagate)
			{
				return event;
			}
		}

		return event;
	}
}
