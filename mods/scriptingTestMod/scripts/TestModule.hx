import simpleclick.modding.events.ScriptEventType;
import simpleclick.modding.events.ScriptEvent;
import simpleclick.modding.modules.Module;

class TestModule extends Module
{
	public function new()
	{
		super('test');
	}

	override function onScriptEvent(event:ScriptEvent)
	{
		if (event.type == ScriptEventType.UPDATE) return event;

		// trace(event.toString());

		return super.onScriptEvent(event);
	}
}
