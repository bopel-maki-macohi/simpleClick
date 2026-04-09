package modding.events;

enum abstract ScriptEventType(String) from String to String
{
  var CREATE = 'CREATE';
  var DESTROY = 'DESTROY';
  var ADDED = 'ADDED';
  var UPDATE = 'UPDATE';

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