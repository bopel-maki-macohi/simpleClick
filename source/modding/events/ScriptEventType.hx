package modding.events;

enum abstract ScriptEventType(String) from String to String
{
  var CREATE = 'CREATE';
  var DESTROY = 'DESTROY';
  var UPDATE = 'UPDATE';

  var STATE_CHANGE_BEGIN = 'STATE_CHANGE_BEGIN';
  var STATE_CHANGE_END = 'STATE_CHANGE_END';

  var OBJECT_CLICK_PRE = 'OBJECT_CLICK_PRE';
  var OBJECT_CLICK_POST = 'OBJECT_CLICK_POST';

  /**
   * Allow for comparing `ScriptEventType` to `String`.
   */
  @:op(A == B) private static inline function equals(a:ScriptEventType, b:String):Bool
    return (a : String) == b;

  /**
   * Allow for comparing `ScriptEventType` to `String`.
   */
  @:op(A != B) private static inline function notEquals(a:ScriptEventType, b:String):Bool
    return (a : String) != b;
}