package simpleclick.modding.events;

import flixel.FlxSprite;
import flixel.FlxState;

class ScriptEvent
{
	public var cancelable(default, null):Bool;

	public var type(default, null):ScriptEventType;

	public var shouldPropagate(default, null):Bool;

	public var eventCanceled(default, null):Bool;

	public var toStringFields(default, null):Array<String> = ['type', 'cancelable', 'eventCanceled'];

	public function new(type:ScriptEventType, cancelable:Bool = false):Void
	{
		this.type = type;
		this.cancelable = cancelable;
		this.eventCanceled = false;
		this.shouldPropagate = true;

		if (!cancelable)
		{
			toStringFields.remove('cancelable');
			toStringFields.remove('eventCanceled');
		}
	}

	public function cancelEvent():Void
		if (cancelable) eventCanceled = true;

	public function cancel():Void
		cancelEvent();

	public function stopPropagation():Void
		shouldPropagate = false;

	public function toString():String
	{
		var message:String = 'ScriptEvent(';

		for (i => field in toStringFields)
		{
			message += '${field}=${Reflect.field(this, field)}';

			if ((i + 1) < toStringFields.length) message += ' | ';
		}

		message += ')';

		return message;
	}
}

class UpdateScriptEvent extends ScriptEvent
{
	public var elapsed(default, null):Float;

	public function new(elapsed:Float):Void
	{
		super(UPDATE, false);

		this.elapsed = elapsed;

		toStringFields.remove('type');
		toStringFields.push('elapsed');
	}
}

class StateChangeScriptEvent extends ScriptEvent
{
	public var currentState(default, null):FlxState;

	public function new(type:ScriptEventType, currentState:FlxState):Void
	{
		super(type, false);
		this.currentState = currentState;

		toStringFields.insert(1, 'currentState');
	}
}

class ObjectScriptEvent extends ScriptEvent
{
	public var object(default, null):FlxSprite;

	public var increment:Int = 1;

	public var highscore(default, null):Bool = false;

	public function new(object:FlxSprite, increment:Int, highscore:Bool, type:ScriptEventType, cancelable:Bool):Void
	{
		super(type, cancelable);

		this.object = object;
		this.increment = increment;
		this.highscore = highscore;

		toStringFields.insert(1, 'object');
		toStringFields.insert(2, 'increment');
		toStringFields.insert(3, 'highscore');
	}
}
