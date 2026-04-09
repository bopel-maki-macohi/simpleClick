package simpleclick;

import simpleclick.modding.PolymodHandler;
import flixel.FlxG;
import polymod.Polymod.ModMetadata;
import flixel.text.FlxText;
import flixel.FlxState;

class ModState extends BaseState
{
	public static var currentSelection:Int = 0;

    public var _text:FlxText;

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

		if (PolymodHandler.allMods.length > 1)
		{
			if (FlxG.keys.anyJustPressed([A, LEFT])) currentSelection--;
			if (FlxG.keys.anyJustPressed([D, RIGHT])) currentSelection++;

			if (FlxG.keys.justReleased.SPACE)
			{
				final mod = PolymodHandler.allMods[currentSelection].dirName;

				if (Save.instance.enabledMods.get().contains(mod)) Save.instance.enabledMods.get().remove(mod);
				else
					Save.instance.enabledMods.get().push(mod);

				PolymodHandler.forceReloadAssets();
			}
		}
	}

	function makeText()
	{
		_text.text = 'No mods';
		_text.screenCenter();

		if (PolymodHandler.allMods.length < 1) return;

		if (currentSelection < 0) currentSelection = 0;
		if (currentSelection > PolymodHandler.allMods.length - 1) currentSelection = PolymodHandler.allMods.length - 1;

		_text.setPosition(0, 0);
		_text.text = '${currentSelection + 1} / ${PolymodHandler.allMods.length}\n\n';

		var mod:ModMetadata = PolymodHandler.allMods[currentSelection];

		_text.text += 'Title: ' + mod.title + '\n';
		_text.text += 'ID: ' + mod.id + '\n\n';

		_text.text += 'Mod Version: ' + mod.modVersion + '\n';
		_text.text += 'API Version: ' + mod.apiVersion + '\n\n';

		_text.text += 'Description:\n' + mod.description + '\n\n';

		_text.text += 'Enabled: ' + Save.instance.enabledMods.get().contains(mod.dirName) + '\n\n';
	}
}
