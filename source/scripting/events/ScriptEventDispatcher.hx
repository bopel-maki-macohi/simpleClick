package scripting.events;

class ScriptEventDispatcher
{
	public static function dispatch(target:Null<IScriptedClass>, event:ScriptEvent)
	{
		// Can't dispatch an event when the target's null
		// Especially when the event itself is null
		if (target == null || event == null) return;

		switch (event.type)
		{
			case Create:
				target.onCreate(event);
			case Update:
				target.onUpdate(cast event);
			case Destroy:
				target.onDestroy(event);
			default:
				// Does literally nothing
		}
	}
}
