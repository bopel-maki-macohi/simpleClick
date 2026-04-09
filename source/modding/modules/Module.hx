package modding.modules;

import modding.IScriptedClass;
import modding.events.ScriptEvent;

/**
 * Parameters used to initialize a module.
 */
typedef ModuleParams =
{
	/**
	 * The state this module is associated with.
	 * If set, this module will only receive events when the game is in this state.
	 */
	?state:Class<Dynamic>
}

/**
 * A module is a scripted class which receives all events without requiring a specific context.
 * You may have the module active at all times, or only when another script enables it.
 */
@:nullSafety
class Module implements IScriptedClass
{
	public var active(default, set):Bool = true;

	function set_active(value:Bool):Bool
	{
		return this.active = value;
	}

	public var moduleId(default, null):String = 'UNKNOWN';

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
}
