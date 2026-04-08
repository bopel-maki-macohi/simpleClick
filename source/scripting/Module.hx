package scripting;

import polymod.hscript.HScriptedClass;

@:hscriptClass
class ScriptedModule extends Module implements HScriptedClass {}

class Module
{
	public var id:String = '';

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return 'Module($id)';
}
