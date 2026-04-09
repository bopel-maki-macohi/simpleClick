package dev;

import haxe.Timer;
import haxe.Json;
import sys.io.File;
import haxe.xml.Access;

/**
 * haxe -m dev.ChangelogTextGenerator --interp
 */
class ChangelogTextGenerator
{
	static var changelogRawXML:String = null;

	static var changelogXml:Access = null;
	static var entrys:Access = null;

	public static function main()
	{
		Timer.measure(f);
	}

	static function f()
	{
		changelogRawXML = sys.io.File.getContent('CHANGELOG.xml');

		changelogXml = new Access(Xml.parse(changelogRawXML));
		entrys = null;

		for (element in changelogXml.elements)
		{
			if (entrys != null) continue;

			if (element.name == 'entrys') entrys = element;
		}

		jsonGen();
		textGen();
	}

	static function textGen()
	{
		var t:String = '';

		var j:Dynamic = Json.parse(File.getContent('assets/data/CHANGELOG.json'));
		var entrys:Array<Dynamic> = j.entrys;

		for (entry in entrys)
		{
			t += '# ${entry.version} - ${entry.date}\n\n';

			var changes:Array<Dynamic> = entry.changes;
			for (change in changes)
			{
				switch (change.type.toLowerCase())
				{
					case 'message':
						t += '${change.change}\n';

						if (entry.changes.filter(d -> return d.type != change.type).length > 0) t += '\n';

					default:
						t += '- ${change.type} : ${change.change}';

						if (change.issuenumber != null) t += ' (https://github.com/bopel-maki-macohi/simpleClick/issues/${change.issuenumber})';
						if (change.link != null) t += ' (${change.link})';

						t += '\n';
				}
			}

			t += '\n';
		}

		t += '<!-- Generated: ${Date.now()} -->';

		File.saveContent('dev/changelogVariations/CHANGELOG.md', t);
	}

	static function jsonGen()
	{
		var j:Dynamic =
			{
				entrys: []
			};

		for (entry in entrys.elements)
		{
			if (entry.name == 'entry')
			{
				var jentry =
					{
						version: entry.att.resolve('version'),
						date: entry.att.resolve('date'),
						changes: [],
					};

				for (entr in entry.elements)
				{
					var issuenumber:String = null;
					var link:String = null;

					if (entr.has.resolve('issuenumber')) issuenumber = entr.att.issuenumber;
					if (entr.has.resolve('link')) link = entr.att.link;

					jentry.changes.push(
						{
							change: entr.innerData,
							type: entr.name,
							issuenumber: issuenumber,
							link: link,
						});
				}

				j.entrys.push(jentry);
			}
		}

		// File.saveContent('dev/changelogVariations/data/CHANGELOG.json', Json.stringify(j, '\t'));
		File.saveContent('assets/data/CHANGELOG.json', Json.stringify(j, '\t'));
	}
}
