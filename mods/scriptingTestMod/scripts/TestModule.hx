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
		super.onScriptEvent(event);

		if (event.type == ScriptEventType.UPDATE) return;

		// trace(event.toString());
	}
}
