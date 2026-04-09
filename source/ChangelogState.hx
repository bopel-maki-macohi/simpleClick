import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class ChangelogState extends BaseState
{
	public static var changelog:ChangelogData = null;

	public var _text:FlxText;

	override function create()
	{
		super.create();

		_text = new FlxText(10, 10, FlxG.width, '', 16);
		add(_text);

		for (entry in ChangelogState.changelog.entrys)
		{
			_text.text += '${entry.version} (${entry.date})\n\n';

			for (change in entry.changes)
			{
				switch (change.type.toLowerCase())
				{
					case 'message':
						_text.text += '${change.change}\n';

						if (entry.changes.filter(d -> return d.type != change.type).length > 0) _text.text += '\n';

					default:
						_text.text += '- ${change.type} : ${change.change}';
						
						// TODO: links to send you to the issue
						if (change.issuenumber != null) _text.text += ' (Issue #${change.issuenumber})';

						_text.text += '\n';
				}
			}

			_text.text += '\n';
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.C) FlxG.switchState(() -> new PlayState());
	}
}
