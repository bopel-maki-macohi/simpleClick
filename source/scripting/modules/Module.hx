package scripting.modules;

import polymod.hscript.HScriptable;
import scripting.events.ScriptEvent;

class Module implements IScriptedClass implements HScriptable
{
	public var id:String = '';

	public var active:Bool = false;

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return '$id | $active';

	function getScriptID():String
		return this.id;

	@:hscript({id: getScriptID})
	public function onCreate(event:ScriptEvent) {}

	@:hscript({id: getScriptID})
	public function onUpdate(event:UpdateScriptEvent) {}

	@:hscript({id: getScriptID})
	public function onDestroy(event:ScriptEvent) {}
}
