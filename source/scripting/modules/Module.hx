package scripting.modules;

import polymod.hscript.HScriptable;
import scripting.events.ScriptEvent;

@:hscript
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

	function getScriptPathName():String
		return 'modules/helloworld/${this.id}';

	@:hscript({pathName: getScriptPathName})
	public function onCreate(event:ScriptEvent) {}

	@:hscript({pathName: getScriptPathName})
	public function onUpdate(event:UpdateScriptEvent) {}

	@:hscript({pathName: getScriptPathName})
	public function onDestroy(event:ScriptEvent) {}
}
