import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxSave;

class Save extends FlxSave
{
	public static var instance:Save;

	override public function new()
	{
		super();

		bind('SimpleClick', 'Maki');

		saveMigration();

		if (!Application.current.onExit.has(save)) Application.current.onExit.add(save);
	}

	function save(l)
	{
		trace(data);

		flush();
	}

	public function saveMigration()
	{
		trace(data);

		final score:SaveField<MInt> = new SaveField<MInt>('score');

		if (score.get() != null)
		{
			trace('Moved to v0.3 (non-score) save');

			version.set(FlxG.stage.application.meta.get('version'));
			highscore.set(score.get());

			Reflect.deleteField(data, 'score');
		}
	}

	public static function getField(field:String):Dynamic
	{
		if (Save.instance == null) return null;
		if (!Save.instance.isBound || Save.instance.isEmpty()) return null;

		return Reflect.getProperty(Save.instance.data, field);
	}

	public static function setField(field:String, value:Dynamic)
	{
		if (Save.instance == null) return;
		if (Save.instance.isBound) Reflect.setProperty(Save.instance.data, field, value);
	}
}
