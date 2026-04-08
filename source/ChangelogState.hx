import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class ChangelogState extends FlxState
{
	public static var _changelog:ChangelogData = null;

	public var _text:FlxText;

	override function create()
	{
		super.create();

		_text = new FlxText(10, 10, FlxG.width, '', 16);
		add(_text);

		for (entry in _changelog.entrys)
		{
			_text.text += '${entry.version} (${entry.date})\n\n';

			for (change in entry.changes)
			{
				switch (change.type.toLowerCase())
				{
					case 'message':
						_text.text += '${change.change}\n';

					default:
						_text.text += '- ${change.type} : ${change.change}\n';
				}
			}
            
			_text.text += '\n';
		}
	}
}
