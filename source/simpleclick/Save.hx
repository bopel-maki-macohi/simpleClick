package simpleclick;

import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxSave;

class Save extends FlxSave
{
	public static var instance:Save;

	public var highscore:SaveField<Null<Int>>;
	public var version:SaveField<String>;
	public var enabledMods:SaveField<Array<String>>;

	public function init()
	{
		bind('SimpleClick', 'Maki');

		highscore = new SaveField<Null<Int>>('highscore', 0);
		version = new SaveField<String>('version', FlxG.stage.application.meta.get('version'));
		enabledMods = new SaveField<Array<String>>('enabledMods', []);

		saveMigration();

		if (!FlxG.stage.application.onExit.has(save)) FlxG.stage.application.onExit.add(save);
	}

	function save(l)
	{
		trace(data);

		flush();
	}

	public function saveMigration()
	{
		trace(data);

		if (data.score != null)
		{
			trace('Moved to v0.3+ (non-score) save');

			var score = data.score;
			highscore.set(score);

			Reflect.deleteField(data, 'score');
		}

		version.set(FlxG.stage.application.meta.get('version'));
	}

	public function getField(field:String):Dynamic
	{
		if (!isBound || isEmpty()) return null;

		return Reflect.getProperty(data, field);
	}

	public function setField(field:String, value:Dynamic)
	{
		if (isBound) Reflect.setProperty(data, field, value);
	}
}
