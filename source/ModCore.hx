import polymod.hscript.HScriptable.HScriptParams;
import macros.ClassMacro;
import polymod.format.ParseRules;
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
		Polymod.clearCache();
		Polymod.clearScripts();

		loadEnabledMods();

		// FlxG.resetState();
	}

	public static var modRoot:String = 'mods';

	public static var apiVersionRule(get, never):VersionRule;

	static function get_apiVersionRule()
	{
		var curVersion:Version = Version.stringToVersion(FlxG.stage.application.meta.get('version'));

		return '>=${curVersion.major}.${curVersion.minor}.0 <${curVersion.major}.${curVersion.minor + 1}.0';
	}

	public static var modFileSystem:Null<ZipFileSystem> = null;

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

		#if !FEATURE_MODDING
		return;
		#end

		// trace('apiVersionRule: $apiVersionRule');

		buildImports();

		// HScriptParams.OPTIONAL_DEFAULT = true;
		// HScriptParams.CANCELLABLE_DEFAULT = true;
		// HScriptParams.RUN_BEFORE_DEFAULT = true;

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
		var idontcare = [FRAMEWORK_INIT, MOD_MISSING_ICON,];

		if (idontcare.contains(e.code)) return;

		trace(Std.string(e.code ?? 'DEBUG').toUpperCase() + ' : ' + e.message);

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

	static function buildImports()
	{
		// Add default imports for common classes.

		// Add import aliases for certain classes.
		// NOTE: Scripted classes are automatically aliased to their parent class.
		Polymod.addImportAlias('flixel.math.FlxPoint', flixel.math.FlxPoint.FlxBasePoint);

		// Add blacklisting for prohibited classes and packages.

		// `Sys`
		// Sys.command() can run malicious processes
		Polymod.blacklistImport('Sys');

		// `Reflect`
		// Reflect.callMethod() can access blacklisted packages
		Polymod.blacklistImport('Reflect');

		// `Type`
		// Type.createInstance(Type.resolveClass()) can access blacklisted packages
		Polymod.blacklistImport('Type');

		// `cpp.Lib`
		// Lib.load() can load malicious DLLs
		Polymod.blacklistImport('cpp.Lib');

		// `polymod.*`
		// You can probably unblacklist a module
		for (cls in ClassMacro.listClassesInPackage('polymod'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `sys.*`
		for (cls in ClassMacro.listClassesInPackage('sys'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `macros.*`
		for (cls in ClassMacro.listClassesInPackage('macros'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `openfl.filesystem.FileStream`, `openfl.net.Socket`, `openfl.utils.ByteArray.ByteArrayData`
		// Returns `Unseralizer.run` if encoded in HXSF format, though it does have to be seralized correctly for the exploit to work.
		#if !html5 Polymod.blacklistInstanceFields(openfl.filesystem.FileStream, ['readObject']); #end
		Polymod.blacklistInstanceFields(openfl.net.Socket, ['readObject']);
		Polymod.blacklistInstanceFields(openfl.utils.ByteArray.ByteArrayData, ['readObject']);

		// `lime.system.CFFI`
		// Can load and execute compiled binaries.
		Polymod.blacklistImport('lime.system.CFFI');

		// `lime.system.JNI`
		// Can load and execute compiled binaries.
		Polymod.blacklistImport('lime.system.JNI');

		// `lime.system.System`
		// System.load() can load malicious DLLs
		Polymod.blacklistImport('lime.system.System');

		// `lime.utils.Assets`
		// Literally just has a private `resolveClass` function for some reason?
		Polymod.blacklistImport('lime.utils.Assets');
		Polymod.blacklistImport('openfl.utils.Assets');
		Polymod.blacklistImport('openfl.Lib');
		Polymod.blacklistImport('openfl.system.ApplicationDomain');
		Polymod.blacklistImport('openfl.net.SharedObject');

		// `openfl.desktop.NativeProcess`
		// Can load native processes on the host operating system.
		Polymod.blacklistImport('openfl.desktop.NativeProcess');

		// `flixel.util.FlxSave`
		// resolveFlixelClasses() can access blacklisted packages
		Polymod.blacklistStaticFields(flixel.util.FlxSave, ['resolveFlixelClasses']);
		// Disallow direct manipulation of save data.
		// Polymod.blacklistStaticFields(flixel.FlxG, ['save']);

		// `haxe.Unserializer`
		// Just to be double-sure, lets blacklist some fields of the Unserializer to make it harder to use if you DO get one.
		Polymod.blacklistStaticFields(haxe.Unserializer, ['run']);
		Polymod.blacklistInstanceFields(haxe.Unserializer, ['unserialize']);

		Polymod.blacklistImport('haxe.Unserializer');

		Polymod.addImportAlias('lime.utils.Assets', AssetsSandboxed);
		Polymod.addImportAlias('openfl.utils.Assets', AssetsSandboxed);
	}
}
