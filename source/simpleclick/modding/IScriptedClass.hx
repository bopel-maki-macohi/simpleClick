package simpleclick.modding;

import simpleclick.modding.events.ScriptEvent;

interface IScriptedClass
{
	public function onScriptEvent(event:ScriptEvent):Void;

	public function onCreate(event:ScriptEvent):Void;
	public function onDestroy(event:ScriptEvent):Void;
	public function onUpdate(event:UpdateScriptEvent):Void;
}

interface IStageChangingScriptedClass extends IScriptedClass
{
	public function onStateChangeBegin(event:StateChangeScriptEvent):Void;
	public function onStateChangeEnd(event:StateChangeScriptEvent):Void;
}

interface IObjectScriptedClass extends IScriptedClass
{
	public function onPreObjectClick(event:ObjectScriptEvent):Void;
	public function onPostObjectClick(event:ObjectScriptEvent):Void;
}
