package modding.events;

import flixel.FlxState;

class ScriptEvent
{
	public var cancelable(default, null):Bool;

	public var type(default, null):ScriptEventType;

	public var shouldPropagate(default, null):Bool;

	public var eventCanceled(default, null):Bool;

	public function new(type:ScriptEventType, cancelable:Bool = false):Void
	{
		this.type = type;
		this.cancelable = cancelable;
		this.eventCanceled = false;
		this.shouldPropagate = true;
	}

	public function cancelEvent():Void
		if (cancelable) eventCanceled = true;

	public function cancel():Void
		cancelEvent();

	public function stopPropagation():Void
		shouldPropagate = false;

	public function toString():String
		return 'type=$type | cancelable=$cancelable)';
}

class UpdateScriptEvent extends ScriptEvent
{
	public var elapsed(default, null):Float;

	public function new(elapsed:Float):Void
	{
		super(UPDATE, false);
		this.elapsed = elapsed;
	}

	public override function toString():String
		return 'elapsed=$elapsed';
}

class StateChangeScriptEvent extends ScriptEvent
{
	public var targetState(default, null):FlxState;

	public function new(type:ScriptEventType, targetState:FlxState, cancelable:Bool = false):Void
	{
		super(type, cancelable);
		this.targetState = targetState;
	}

	public override function toString():String
		return 'type=' + type + ' | targetState=' + targetState;
}
