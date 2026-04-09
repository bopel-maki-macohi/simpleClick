package modding;

import modding.modules.ModuleHandler;
import macros.ClassMacro;
import thx.semver.Version;
import thx.semver.VersionRule;
import flixel.FlxG;
import polymod.fs.ZipFileSystem;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules.TextFileFormat;
import polymod.Polymod;

class PolymodHandler
{
	public static var API_VERSION(get, never):String;

	static function get_API_VERSION():String
	{
		return FlxG.stage.application.meta.get('version');
	}

	/**
	 * The Semantic Versioning rule
	 * Indicates which mods are compatible with this version of the game.
	 * Using more complex rules allows mods from older compatible versions to stay functioning,
	 * while preventing mods made for future versions from being installed.
	 */
	public static var API_VERSION_RULE(get, never):VersionRule;

	static function get_API_VERSION_RULE()
	{
		var curVersion:Version = Version.stringToVersion(FlxG.stage.application.meta.get('version'));

		return '>=${curVersion.major}.${curVersion.minor}.0 <${curVersion.major}.${curVersion.minor + 1}.0';
	}

	/**
	 * Where relative to the executable that mods are located.
	 */
	static final MOD_FOLDER:String =
		#if (REDIRECT_ASSETS_FOLDER && mac)
		'../../../../../../../example_mods'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../example_mods'
		#else
		'mods'
		#end;

	static final CORE_FOLDER:Null<String> =
		#if (REDIRECT_ASSETS_FOLDER && mac)
		'../../../../../../../assets'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../assets'
		#else
		null
		#end;

	public static var loadedModDirs:Array<String> = [];
	public static var loadedModIds:Array<String> = [];

	// Use SysZipFileSystem on native and MemoryZipFilesystem on web.
	static var modFileSystem:Null<ZipFileSystem> = null;

	/**
	 * If the mods folder doesn't exist, create it.
	 */
	public static function createModRoot():Void
	{
		#if sys
		if (!sys.FileSystem.exists(MOD_FOLDER)) sys.FileSystem.createDirectory(MOD_FOLDER);
		#end
	}

	public static function loadAllMods():Void
	{
		createModRoot();

		trace('Initializing Polymod (using all mods)...');
		loadModsByDir(getAllModDirs());
	}

	public static function loadEnabledMods():Void
	{
		createModRoot();

		trace('Initializing Polymod (using configured mods)...');
		loadModsByDir(Save.instance.enabledMods.get());
	}

	public static function loadNoMods():Void
	{
		createModRoot();

		trace('Initializing Polymod (using no mods)...');
		loadModsByDir([]);
	}

	public static function loadModsByDir(dirs:Array<String>):Void
	{
		if (dirs.length == 0)
		{
			trace('You attempted to load zero mods.');
		}
		else
		{
			trace('Attempting to load ${dirs.length} mods...');
		}

		buildImports();

		if (modFileSystem == null) modFileSystem = buildFileSystem();

		var loadedModList:Array<ModMetadata> = polymod.Polymod.init(
			{
				// Root directory for all mods.
				modRoot: MOD_FOLDER,
				// The directories for one or more mods to load.
				dirs: dirs,
				// Framework being used to load assets.
				framework: OPENFL,
				// The current version of our API.
				apiVersionRule: API_VERSION_RULE,
				// Call this function any time an error occurs.
				errorCallback: PolymodErrorHandler.onError,
				// Enforce semantic version patterns for each mod.
				// modVersions: null,
				// A map telling Polymod what the asset type is for unfamiliar file extensions.
				// extensionMap: [],

				customFilesystem: modFileSystem,

				frameworkParams: buildFrameworkParams(),

				// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
				ignoredFiles: buildIgnoreList(),

				// Parsing rules for various data formats.
				parseRules: buildParseRules(),

				skipDependencyErrors: true,

				// Parse hxc files and register the scripted classes in them.
				useScriptedClasses: true,
				loadScriptsAsync: #if html5 true #else false #end,
			});

		if (loadedModList == null)
		{
			trace('An error occurred! Failed when loading mods!');
		}
		else
		{
			if (loadedModList.length == 0)
			{
				trace('Mod loading complete. We loaded no mods / ${dirs.length} mods.');
			}
			else
			{
				trace('Mod loading complete. We loaded ${loadedModList.length} / ${dirs.length} mods.');
			}
		}

		loadedModIds = [];
		loadedModDirs = [];
		for (mod in loadedModList)
		{
			trace(' * ${mod.title} v${mod.modVersion} [${mod.id}]');
			loadedModDirs.push(mod.dirName);
			loadedModIds.push(mod.id);
		}

		#if FEATURE_MODDING_MODFILELISTS
		var fileList:Array<String> = Polymod.listModFiles(PolymodAssetType.IMAGE);
		trace('Installed mods have added/replaced ${fileList.length} images.');
		for (item in fileList)
		{
			trace(' * $item');
		}

		fileList = Polymod.listModFiles(PolymodAssetType.TEXT);
		trace('Installed mods have added/replaced ${fileList.length} text files.');
		for (item in fileList)
		{
			trace(' * $item');
		}

		fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_MUSIC);
		trace('Installed mods have replaced ${fileList.length} music files.');
		for (item in fileList)
		{
			trace(' * $item');
		}

		fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_SOUND);
		trace('Installed mods have replaced ${fileList.length} sound files.');
		for (item in fileList)
		{
			trace(' * $item');
		}

		fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_GENERIC);
		trace('Installed mods have replaced ${fileList.length} generic audio files.');
		for (item in fileList)
		{
			trace(' * $item');
		}
		#end
	}

	static function buildFileSystem():polymod.fs.ZipFileSystem
	{
		polymod.Polymod.onError = PolymodErrorHandler.onError;
		return new ZipFileSystem(
			{
				modRoot: MOD_FOLDER,
				autoScan: true
			});
	}

	static function buildImports():Void
	{
		// Add default imports for common classes.
		static final DEFAULT_IMPORTS:Array<Class<Dynamic>> = [flixel.FlxG, AssetsSandboxed];

		for (cls in DEFAULT_IMPORTS)
		{
			Polymod.addDefaultImport(cls);
		}

		// `lime.utils.Assets` literally just has a private `resolveClass` function for some reason? so we replace it with our own.
		Polymod.addImportAlias('lime.utils.Assets', AssetsSandboxed);
		Polymod.addImportAlias('openfl.utils.Assets', AssetsSandboxed);

		// `Sys`
		// Sys.command() can run malicious processes
		Polymod.blacklistImport('Sys');

		// `Reflect`
		// Reflect.callMethod() can access blacklisted packages, but some functions are whitelisted
		Polymod.blacklistStaticFields(Reflect, ['callMethod']);

		// `Type`
		// Type.createInstance(Type.resolveClass()) can access blacklisted packages, but some functions are whitelisted
		Polymod.blacklistStaticFields(Type, ['createInstance', 'resolveClass']);

		// `cpp.Lib`
		// Lib.load() can load malicious DLLs
		Polymod.blacklistImport('cpp.Lib');

		// `haxe.Unserializer`
		// Unserializer.DEFAULT_RESOLVER.resolveClass() can access blacklisted packages
		Polymod.blacklistImport('haxe.Unserializer');

		// `lime.utils.AssetLibrary`
		// If you create your own library using a manifest, AssetLibrary.__fromManifest() can access blacklisted packages apparently.
		Polymod.blacklistImport('lime.utils.AssetLibrary');

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
		Polymod.blacklistStaticFields(flixel.FlxG, ['save']);

		// `haxe.Unserializer`
		// Just to be double-sure, lets blacklist some fields of the Unserializer to make it harder to use if you DO get one.
		Polymod.blacklistStaticFields(haxe.Unserializer, ['run']);
		Polymod.blacklistInstanceFields(haxe.Unserializer, ['unserialize']);

		// `funkin.save.Save`
		// Direct access to save data is important for scripts (like checking unlocks),
		// but we don't want scripts to be able to perform operations like writing scores.
		Polymod.blacklistInstanceFields(Save, [
			// No direct field access
			'data', // LMFAO definitely not
		]);

		// `openfl.filesystem.FileStream`, `openfl.net.Socket`, `openfl.utils.ByteArray.ByteArrayData`
		// Returns `Unseralizer.run` if encoded in HXSF format, though it does have to be seralized correctly for the exploit to work.
		#if !html5 Polymod.blacklistInstanceFields(openfl.filesystem.FileStream, ['readObject']); #end
		Polymod.blacklistInstanceFields(openfl.net.Socket, ['readObject']);
		Polymod.blacklistInstanceFields(openfl.utils.ByteArray.ByteArrayData, ['readObject']);

		// `polymod.*`
		// Contains functions which may allow for un-blacklisting other modules.
		for (cls in ClassMacro.listClassesInPackage('polymod'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `hscript.*
		// Contains functions which may allow for interpreting unsanitized strings.
		for (cls in ClassMacro.listClassesInPackage('hscript'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `sys.*`
		// Access to system utilities such as the file system.
		for (cls in ClassMacro.listClassesInPackage('sys'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}

		// `macros.*`
		// CompiledClassList's get function allows access to sys
		// None of the classes are suitable for mods anyway
		for (cls in ClassMacro.listClassesInPackage('macros'))
		{
			if (cls == null) continue;
			var className:String = Type.getClassName(cls);
			Polymod.blacklistImport(className);
		}
	}

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

	static inline function buildFrameworkParams():polymod.Polymod.FrameworkParams
	{
		return {
			assetLibraryPaths: ['default' => 'default', 'scripts' => 'scripts',],
			coreAssetRedirect: CORE_FOLDER,
		}
	}

	public static var allMods:Array<ModMetadata> = [];

	public static function getAllMods():Array<ModMetadata>
	{
		trace('Scanning the mods folder...');
		allMods = [];

		if (modFileSystem == null) modFileSystem = buildFileSystem();

		allMods = Polymod.scan(
			{
				modRoot: MOD_FOLDER,
				apiVersionRule: API_VERSION_RULE,
				fileSystem: modFileSystem,
				errorCallback: PolymodErrorHandler.onError
			});
		trace('Found ${allMods.length} mods when scanning.');
		return allMods;
	}

	public static function getAllModIds():Array<String>
	{
		var modIds:Array<String> = [for (i in getAllMods()) i.id];
		return modIds;
	}

	public static function getAllModDirs():Array<String>
	{
		var modDirs:Array<String> = [for (i in getAllMods()) i.dirName];
		return modDirs;
	}

	public static function getEnabledMods():Array<ModMetadata>
	{
		var modDirs:Array<String> = Save.instance.enabledMods.get();
		var modMetadata:Array<ModMetadata> = getAllMods();
		var enabledMods:Array<ModMetadata> = [];
		for (item in modMetadata)
		{
			if (modDirs.indexOf(item.dirName) != -1)
			{
				enabledMods.push(item);
			}
		}
		return enabledMods;
	}

	public static function forceReloadAssets():Void
	{
		ModuleHandler.clearModuleCache();
		Polymod.clearScripts();

		PolymodHandler.getAllMods();
		PolymodHandler.loadEnabledMods();

		ModuleHandler.loadModuleCache();
		ModuleHandler.callOnCreate();
	}
}
