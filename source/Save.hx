import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxSave;

class Save extends FlxSave
{
	public static var instance:Save;

	public var highscore:SaveField<Int>;
	public var version:SaveField<String>;

	override public function new()
	{
		super();

		bind('SimpleClick', 'Maki');

		highscore = new SaveField<Int>('highscore');
		version = new SaveField<String>('version');

		saveMigration();

		Application.current.onExit.add((l) -> flush());
	}

	@:haxe.warning("-WDeprecated")
	public function saveMigration()
	{
		trace(data);

		switch (version.get)
		{
			case null:
				final score:SaveField<Int> = new SaveField<Int>('score');

				if (score != null)
				{
					trace('Moved to v0.3 save');

					version.set(FlxG.stage.application.meta.get('version'));
					highscore.set(score.get());

					Reflect.deleteField(data, score.field);
				}
		}
	}

	public static function getField(field:String):Dynamic
	{
		if (!Save.instance.isBound || Save.instance.isEmpty()) return null;

		return Reflect.getProperty(Save.instance.data, field);
	}

	public static function setField(field:String, value:Dynamic)
	{
		if (Save.instance.isBound) Reflect.setProperty(Save.instance.data, field, value);
	}
}
