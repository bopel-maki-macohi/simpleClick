package scripting.events;

class ScriptEvent
{
	public var type(default, null):ScriptEventType;
	public var cancelled(default, null):Bool = false;

	public function new(type:ScriptEventType)
	{
		this.type = type;
	}

	public function cancel()
		cancelled = true;

	public function toString():String
		return '$type | $cancelled';
}

class UpdateScriptEvent extends ScriptEvent
{
	public var elapsed(default, null):Float;

	override public function new(elapsed:Float)
	{
		super(Update);

		this.elapsed = elapsed;
	}
}
