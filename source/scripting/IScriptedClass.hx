package scripting;

import scripting.events.ScriptEvent;

interface IScriptedClass
{
	public function onCreate(event:ScriptEvent):Void;
	public function onUpdate(event:UpdateScriptEvent):Void;
	public function onDestroy(event:ScriptEvent):Void;
}
