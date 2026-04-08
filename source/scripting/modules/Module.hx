package scripting.modules;

import scripting.events.ScriptEvent;

class Module implements IScriptedClass
{
	public var id:String = '';

	public var active:Bool = false;

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return '$id | $active';

	public function onCreate(event:ScriptEvent) {}

	public function onUpdate(event:UpdateScriptEvent) {}

	public function onDestroy(event:ScriptEvent) {}
}
