package simpleclick.modding.modules;

import simpleclick.modding.IScriptedClass;
import simpleclick.modding.events.ScriptEvent;

typedef ModuleParams =
{
	?state:Class<Dynamic>
}

@:nullSafety
class Module implements IStageChangingScriptedClass implements IObjectScriptedClass
{
	public var active(default, set):Bool = true;

	function set_active(value:Bool):Bool
	{
		return this.active = value;
	}

	public var moduleId(default, null):String = 'UNKNOWN';

	/**
	 * Determines the order in which modules receive events.
	 * You can modify this to change the order in which a given module receives events.
	 *
	 * Priority 1 is processed before Priority 1000, etc.
	 */
	public var priority(default, set):Int = 1000;

	function set_priority(value:Int):Int
	{
		this.priority = value;
		@:privateAccess
		ModuleHandler.reorderModuleCache();
		return value;
	}

	public var state:Null<Class<Dynamic>> = null;

	public function new(moduleId:String, priority:Int = 1000, ?params:ModuleParams):Void
	{
		this.moduleId = moduleId;
		this.priority = priority;

		if (params != null)
		{
			this.state = params.state ?? null;
		}
	}

	public function toString():String
		return '$moduleId';

	public function onScriptEvent(event:ScriptEvent) {}

	public function onCreate(event:ScriptEvent) {}
	public function onDestroy(event:ScriptEvent) {}
	public function onUpdate(event:UpdateScriptEvent) {}

	public function onStateChangeBegin(event:StateChangeScriptEvent) {}
	public function onStateChangeEnd(event:StateChangeScriptEvent) {}

	public function onPreObjectClick(event:ObjectScriptEvent) {}
	public function onPostObjectClick(event:ObjectScriptEvent) {}
}
