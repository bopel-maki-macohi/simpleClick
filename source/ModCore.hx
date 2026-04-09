import polymod.format.ParseRules;
import scripting.modules.ModuleHandler;
import flixel.FlxG;
import thx.semver.Version;
import thx.semver.VersionRule;
import polymod.Polymod;
import polymod.fs.ZipFileSystem;

using StringTools;

class ModCore
{
	public static function reload()
	{
		ModuleHandler.clear();

		// Polymod.clearCache();
		// Polymod.clearScripts();
		// Polymod.reload();

		loadEnabledMods();

		ModuleHandler.load();
		// FlxG.resetState();
	}

	public static var modRoot:String = './mods/';

	public static var apiVersionRule(get, never):VersionRule;

	static function get_apiVersionRule()
	{
		var curVersion:Version = Version.stringToVersion(FlxG.stage.application.meta.get('version'));

		return '>=${curVersion.major}.${curVersion.minor}.0 <${curVersion.major}.${curVersion.minor + 1}.0';
	}

	static var modFileSystem:Null<ZipFileSystem> = null;

	public static function loadEnabledMods()
	{
		makeModRoot();
		loadMods(Save.instance.enabledMods.get());
	}

	public static function loadAllMods()
	{
		makeModRoot();
		loadMods(getAllModDirs());
	}

	static function makeModRoot()
	{
		#if sys
		if (!sys.FileSystem.exists(modRoot)) sys.FileSystem.createDirectory(modRoot);
		#end
	}

	public static var loadedModDirs:Array<String> = [];
	public static var loadedModIds:Array<String> = [];
	public static var validModMetadatas:Array<ModMetadata> = [];

	static function loadMods(mods:Array<String>)
	{
		Polymod.onError = onError;
		if (modFileSystem == null) modFileSystem = buildFileSystem();

		// trace('apiVersionRule: $apiVersionRule');

		// buildImports here

		var loadedModList:Array<ModMetadata> = Polymod.init(
			{
				modRoot: modRoot,
				apiVersionRule: apiVersionRule,

				dirs: mods,

				framework: OPENFL,

				customFilesystem: modFileSystem,

				// frameworkParams: buildFrameworkParams(),

				// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
				ignoredFiles: buildIgnoreList(),

				// Parsing rules for various data formats.
				parseRules: buildParseRules(),

				skipDependencyErrors: true,

				// Parse hxc (+ hx) files and register the scripted classes in them.
				useScriptedClasses: true,
				loadScriptsAsync: #if html5 true #else false #end,
			});

		if (loadedModList == null) trace('An error occurred! Failed when loading mods!');
		else if (loadedModList.length == 0) trace('Mod loading complete. We loaded no mods / ${mods.length} mods.');
		else
			trace('Mod loading complete. We loaded ${loadedModList.length} / ${mods.length} mods.');

		loadedModIds = [];
		loadedModDirs = [];
		for (mod in loadedModList)
		{
			trace(' * ${mod.title} v${mod.modVersion} [${mod.id}]');
			loadedModDirs.push(mod.dirName);
			loadedModIds.push(mod.id);
		}
	}

	static function buildFileSystem():polymod.fs.ZipFileSystem
	{
		return new ZipFileSystem(
			{
				modRoot: modRoot,
				autoScan: true
			});
	}

	public static function getAllModDirs()
	{
		var dirs = [];

		for (meta in getValidModMetas())
			dirs.push(meta.dirName);

		return dirs;
	}

	public static function getValidModMetas()
	{
		validModMetadatas = Polymod.scan(
			{
				modRoot: modRoot,
				apiVersionRule: apiVersionRule,
			});

		return validModMetadatas;
	}

	static function onError(e:PolymodError)
	{
		var idontcare = [FRAMEWORK_INIT, MOD_MISSING_ICON, MOD_LOAD_START, MOD_LOAD_DONE,];

		if (e.code == FRAMEWORK_INIT || e.code == MOD_MISSING_ICON) return;

		trace(Std.string(e.code).toUpperCase() + ' : ' + e.message);

		if (e.severity == ERROR || e.code == MOD_DEPENDENCY_UNMET) FlxG.stage.application.window.alert(e.message);
	}

	/**
	 * Build a list of file paths that will be ignored in mods.
	 */
	static function buildIgnoreList():Array<String>
	{
		var result = Polymod.getDefaultIgnoreList();

		result.push('.vscode');
		result.push('.idea');
		result.push('.git');
		result.push('.gitignore');
		result.push('.gitattributes');
		result.push('README.md');

		return result;
	}

	static function buildParseRules():polymod.format.ParseRules
	{
		var output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType('txt', TextFileFormat.LINES);

		// You can specify the format of a specific file, with file extension.
		// output.addFile("data/introText.txt", TextFileFormat.LINES)
		return output;
	}
}
