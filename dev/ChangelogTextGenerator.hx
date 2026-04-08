package dev;

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
		changelogRawXML = sys.io.File.getContent('dev/changelogVariations/CHANGELOG.xml');

		changelogXml = new Access(Xml.parse(changelogRawXML));
		entrys = null;
			
		for (element in changelogXml.elements)
		{
			if (entrys != null) continue;

			if (element.name == 'entrys') entrys = element;
		}

		textGen();
		jsonGen();
	}

	static function textGen()
	{
		var t:String = '';

		for (entry in entrys.elements)
		{
			if (entry.name == 'entry')
			{
				t += '# ' + entry.att.resolve('version') + ' - ' + entry.att.resolve('date') + '\n\n';

				for (entr in entry.elements)
				{
					if (entr.name == 'message') t += entr.innerData;
					else
						t += '- ' + entr.name + ' : ' + entr.innerData;
					t += '\n';
				}

				t += '\n';
			}
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
					jentry.changes.push(
						{
							change: entr.innerData,
							changeType: entr.name,
						});
				}

				j.entrys.push(jentry);
			}
		}

		File.saveContent('dev/changelogVariations/CHANGELOG.json', Json.stringify(j, '\t'));
	}
}
