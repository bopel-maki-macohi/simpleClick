package simpleclick.modding;

import simpleclick.modding.events.ScriptEvent;

interface IScriptedClass
{
	public function onScriptEvent(event:ScriptEvent):ScriptEvent;

	public function onCreate(event:ScriptEvent):ScriptEvent;
	public function onDestroy(event:ScriptEvent):ScriptEvent;
	public function onUpdate(event:UpdateScriptEvent):UpdateScriptEvent;
}

interface IStageChangingScriptedClass extends IScriptedClass
{
	public function onStateChangeBegin(event:StateChangeScriptEvent):StateChangeScriptEvent;
	public function onStateChangeEnd(event:StateChangeScriptEvent):StateChangeScriptEvent;
}

interface IObjectScriptedClass extends IScriptedClass
{
	public function onPreObjectClick(event:ObjectScriptEvent):ObjectScriptEvent;
	public function onPostObjectClick(event:ObjectScriptEvent):ObjectScriptEvent;
}
