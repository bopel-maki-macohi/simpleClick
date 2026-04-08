import flixel.util.FlxSave;

class Save extends FlxSave
{
	public static var _instance:Save;

	override public function new()
	{
		super();

		bind('SimpleClick', 'Maki');
	}

	public var score(get, set):Int;

	function get_score():Int
	{
		return data.score ?? 0;
	}

	function set_score(score:Int):Int
	{
		data.score = score;
		return score;
	}
}
