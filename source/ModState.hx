import flixel.FlxG;
import polymod.Polymod.ModMetadata;
import flixel.text.FlxText;
import flixel.FlxState;

class ModState extends FlxState
{
	public var _text:FlxText;

	public var _currentSelection:Int = 0;

	override function create()
	{
		super.create();

		_text = new FlxText(0, 0, 0, '', 16);
		add(_text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		makeText();

		if (FlxG.keys.justReleased.M) FlxG.switchState(() -> new PlayState());
	}

	function makeText()
	{
		_text.text = 'No mods';
		_text.screenCenter();

		if (ModCore.loadedModIds.length < 1) return;

		_text.setPosition(0, 0);
		_text.text = '${_currentSelection + 1} / ${ModCore.loadedModIds.length}\n\n';

		var mod:ModMetadata = ModCore.loadedModMetadatas[_currentSelection];

		_text.text += 'Title: ' + mod.title + '\n';
		_text.text += 'ID: ' + mod.id + '\n\n';
		
        _text.text += 'Mod Version: ' + mod.modVersion + '\n';
		_text.text += 'API Version: ' + mod.apiVersion + '\n\n';

		_text.text += 'Description: ' + mod.description + '\n\n';
	}
}
