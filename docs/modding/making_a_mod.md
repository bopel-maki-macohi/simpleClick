# SimpleClick Modding Docs : Making a Mod

Ok so the game uses [Polymod](https://polymod.io/) for mod support n script stuff so I'm gonna link [this](https://polymod.io/docs/mod-metadata/) page for the official mod making "tutorial", but it's a lil outdated (as of writing this) so I'm gonna do sum yappin.

## Metadata

Here are the steps to get your mod loadin' in the game

1. Create a new folder within the `mods` folder.
2. Create a new text file, and change its name to `_polymod_meta.json`. Make sure you didn't accidentally name it `_polymod_meta.json.txt`!

Inside this file, we will put the information the game needs in order to learn about your mod. I recommend doing this with a program like [Visual Studio Code](https://code.visualstudio.com/), it will correct you if you accidentally misplace a comma or something.

```jsonc
{
  "title": "Intro Mod",
  "description": "An introductory mod.",
  "contributors": [
    {
      "name": "EliteMasterEric", // These docs are based on the FNF onces hehehehe
    },
  ],
  "dependencies": {
    "modA": "1.0.0",
  },
  "optionalDependencies": {
    "modB": "1.3.2",
  },
  "api_version": "0.8.0",
  "mod_version": "1.0.0",
  "license": "Apache-2.0",
}
```

`_polymod_meta.json` has the following fields:

- `id`: Internal name for the mod that will be what it's refered to as, you can change this but by default it's the folder name.
- `title`: A readable name for the mod.
- `description`: A readable description for the mod.
- `contributors`: A list of Contributor objects.
- `homepage`: A URL where users can learn more about your mod.
- `dependencies`: A map of mod IDs which are mandatory dependencies, along with their version numbers.
  - These are the mods which must also be loaded in order for this mod to load.
  - If the mod is not included, it will fail.
  - The mod list will be reordered such that dependencies load first.
- `optionalDependencies`: A map of mod IDs which are optional dependencies, along with their version numbers.
  - These mods do not necessarily need to be installed for this mod to load, but they will still force the mod list to be reordered so that the dependencies load before this mod.
- `api_version`: A version number used to determine if mods are compatible with your copy of Funkin'. Change this to the version number for Friday Night Funkin' that you want to support, preferably the latest one (`0.8.0` at time of writing.).
- `mod_version`: A version number specifically for your mod. Choose any version or leave it at `1.0.0`.
- `license`: The license your mod is distributed under. [Pick one from here](https://opensource.org/licenses) or just leave it as `Apache-2.0`.

A Contributor has the following fields:

- `name`: The contributor's name.
- `role`: _(optional)_ The role the contributor played, for example "Artist" or "Programmer"
- `email`: _(optional)_ A contact email
- `url`: _(optional)_ A homepage URL

Many of these fields are intended to be used in the future by an upcoming Mod Menu interface, which will allow users to organize their mods.

## Mod loading

Now that you have a metadata file, you can start the game!
Pro tip, if you run the game from the command line, you can see lots of useful debug messages, like these messages that indicate your mod has loaded!

```shell
source/modding/PolymodHandler.hx:106: Attempting to load 1 mod(s)...
...
source/modding/PolymodErrorHandler.hx:21: MOD_LOAD_START : Preparing to load mod mods/introMod
source/modding/PolymodErrorHandler.hx:21: MOD_LOAD_DONE : Done loading mod mods/introMod
...
source/modding/PolymodHandler.hx:159: Mod loading complete. We loaded 1 / 1 mods.
```

Neat! But right now, your mod doesn't do anything.

# Asset Replacement

The key thing that Polymod allows you to do is to replace assets. This is done by adding those files to your mods folder in the same location as they would go.

For example, you can replace the changelog by placing the new json in the data folder of your mod!

In other words, structure your mod like so:

```
-assets
-manifest
-plugins
-mods
 |-myMod
   |-data
     |-CHANGELOG.json
   |-_polymod_meta.json
-SimpleClick.exe
```

When the game goes to load the changelog, it'll look in `assets/data/CHANGELOG.json`, but polymod will make it look through the mods for them first.

# Asset Additions

Polymod also allows you to add new files to the game.
This is notable, as trying to place new files into the `assets` directory doesn't work, the game won't recognize those files.

# Mod Load Order

You may wonder what happens in the case where multiple mods provide a given file.

The answer is simple; mod order matters.

If you have two mods installed which replace a particular asset, the mod which loads last will get precedence over mods that get loaded earlier, similar to Minecraft's resource pack system.

This is evaluated on a per-file basis, so if Mod A adds a script with the name "MODULE7".
And Mod B has 3 scripts: "m8y", "MODU", and "MODULE7" and Mod B is loaded after Mod A, you'll see the "MODULE7" script from Mod A and the other scripts from Mod B.

In the current version of the game, there is no accessible means of altering mod load order.
Mods will load in alphabetical order by default, with dependencies being loaded first.

might be changed in the future though, we'll see.

# Hot Reloading

While developing your mod, you may find it inconvenient to make a change, open the game, encounter an error or visual issue, have to close the game, make another change, then open the game again and start the process over and over in order to achieve the desired results for your custom content.

Thankfully, there is a better way! **Press F5 to force the game to dump its cache and reload all game data from disk,** then restart the current state with the appropriate changes applied. This lets you, for example:

- Modify a script to resolve an exception and reload to continue testing without closing the game.
- Make a script to fuck around and find out hehehe

> Main Author (Technically): [EliteMasterEric](https://github.com/EliteMasterEric)
> Sub Author: [Maki](https://github.com/bopel-maki-macohi)
>
> > I changed it to be more SimpleClick
