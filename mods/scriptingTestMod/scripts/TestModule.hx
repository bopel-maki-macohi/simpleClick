import modding.events.ScriptEventType;
import modding.events.ScriptEvent;
import modding.modules.Module;

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

		trace(event.toString());
	}
}
