import scripting.events.ScriptEvent;
import scripting.modules.Module;

class ExampleModule extends Module
{
	override public function new()
	{
		super('example-module');
	}

	override function onCreate(event:ScriptEvent)
	{
		super.onCreate(event);

		trace(event);
	}
}
