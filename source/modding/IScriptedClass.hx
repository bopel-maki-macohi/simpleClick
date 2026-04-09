package modding;

import modding.events.ScriptEvent;

interface IScriptedClass
{
	public function onScriptEvent(event:ScriptEvent):Void;

	public function onCreate(event:ScriptEvent):Void;
	public function onDestroy(event:ScriptEvent):Void;
	public function onUpdate(event:UpdateScriptEvent):Void;
}
