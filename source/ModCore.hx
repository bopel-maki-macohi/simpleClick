import flixel.FlxG;
import thx.semver.Version;
import thx.semver.VersionRule;
import polymod.Polymod;
import polymod.fs.ZipFileSystem;

class ModCore
{
	public static var modRoot:String = 'mods/';

	public static var apiVersionRule(get, never):VersionRule;

	static function get_apiVersionRule()
	{
		var curVersion:Version = Version.stringToVersion(FlxG.stage.application.meta.get('version'));

		return '>=${curVersion.major}.${curVersion.minor}.0 <${curVersion.major}.${curVersion.minor + 1}.0';
	}

	static var modFileSystem:Null<ZipFileSystem> = null;

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

	static function loadMods(mods:Array<String>)
	{
		if (modFileSystem == null) modFileSystem = buildFileSystem();

		trace('apiVersionRule: $apiVersionRule');

		// buildImports here

		var loadedModList:Array<ModMetadata> = Polymod.init(
			{
				modRoot: modRoot,
				apiVersionRule: apiVersionRule,
				errorCallback: onError,

				dirs: mods,

				framework: OPENFL,

				customFilesystem: modFileSystem,

				//   frameworkParams: buildFrameworkParams(),

				// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
				//   ignoredFiles: buildIgnoreList(),

				// Parsing rules for various data formats.
				//   parseRules: buildParseRules(),

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
		Polymod.onError = onError;
		return new ZipFileSystem(
			{
				modRoot: modRoot,
				autoScan: true
			});
	}

	static function getAllModDirs()
	{
		var dirs = [];

		for (meta in getModMetas())
			dirs.push(meta.dirName);

		return dirs;
	}

	static function getModMetas()
	{
		return Polymod.scan(
			{
				modRoot: modRoot,
				errorCallback: onError,
				apiVersionRule: apiVersionRule,
			});
	}

	static function onError(error:PolymodError)
	{
		trace('[${error.severity} / ${error.code}]'.toUpperCase() + ' ${error.message}');
	}
}
