# SimpleClick Modding Docs : Script Events

I'm just gonna quickly summarize the script events and their functions ngl.

## Note

Every event calls `onScriptEvent(event:ScriptEvent)`. So they all go through there before the other event functions do or don't get called

## Script Events

- CREATE : Calls `onCreate(event:ScriptEvent)`
    - Calls when modules get loaded

- DESTROY : Calls `onDestroy(event:ScriptEvent)`
    - Calls when modules get cleared

- UPDATE : Calls `onUpdate(event:UpdateScriptEvent)`
    - Calls every frame in every state
    - (Important) Fields:
        - `elapsed` : The update function `elapsed` variable
    - Not Cancellable

- STATE_CHANGE_BEGIN : Calls `onStateChangeBegin(event:StateChangeScriptEvent)`
    - Calls right before a state change

- STATE_CHANGE_END : Calls `onStateChangeBegin(event:StateChangeScriptEvent)`
    - Calls right after a state change

- OBJECT_CLICK_PRE : Calls `onPreObjectClick(event:ObjectScriptEvent)`
    - Calls before the object click goes through
    - (Important) Fields:
        - `object` : The object
        - `increment` : Base Score you'll get from clicking the object if the event isn't cancelled
    - Cancellable : Prevents the score increment, "score > highscore" check, and OBJECT_CLICK_POST event dispatch

- OBJECT_CLICK_POST : Calls `onPostObjectClick(event:ObjectScriptEvent)`
    - Calls after the object click goes through and the score increment and "score > highscore" check
    - (Important) Fields:
        - `object` : The object
    - Cancellable : Prevents the lil object anim (how could you)
