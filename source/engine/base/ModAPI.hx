package engine.base;

import lime.app.Application;
import cpp.abi.Abi;
import openfl.display.BitmapData;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.media.Sound;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

using StringTools;

/**
 * Raw modding API. It's recommended to use the Modding class instead as it acts as a wrapper to make things easier.
 * 
 * ### FOR ADVANCED USERS ONLY
 * @since 1.3.0-SC542
 */
class ModAPI
{
    /**
     * List of currently loaded mods.
     * @since 1.3.0-SC542
     */
    public var loaded:Array<Mod>;

    /**
        Mods that don't match this version are "deprecated" but will still work.
        @since 1.5.0
    **/
    public static var modVerIndex:Int = 0;

    public function new()
    {
        #if !NO_MODDING
        loaded = new Array<Mod>();
        #end
    }

    public function init(modFolderPath:String)
    {
        #if !NO_MODDING
        for (file in FileSystem.readDirectory(modFolderPath))
        {
            trace("Inspecting file: " + modFolderPath + file);
            if (FileSystem.isDirectory(modFolderPath + file))
            {
                trace("found mod: " + file);
                if (!FileSystem.exists(modFolderPath + file + "/mod.json"))
                {
                    Application.current.window.alert("Mod " + file + " is missing mod.json", "Mod Error");
                    continue;
                }
                var meta:ModMeta = Json.parse(File.getContent(modFolderPath + file + "/mod.json"));
                if (meta.versionIndex != modVerIndex)
                {
                    Application.current.window.alert("Mod " + file + " has version index " + meta.versionIndex + " but this version of FNF# uses version index " + modVerIndex + ".\n\nThe mod will still run, but some features may not work as expected, or even crash the game. Run at your own risk.", "DEPRECATED MOD");
                }
                loaded.push({
                    name: file.split("SM.")[1],
                    meta: meta,
                    path: modFolderPath + file
                });
            }
        }
        trace("Found " + loaded.length + " mod(s).");
        trace("Inspecting dependencies...");
        for (mod in loaded)
        {
            for (dependency in mod.meta.dependencies)
            {
                trace("Looking for dependency: " + dependency);
                var found:Bool = false;
                for (loadedMod in loaded)
                {
                    if (loadedMod.meta.modID == dependency.modID && loadedMod.meta.versionIndex == dependency.versionIndex)
                    {
                        trace("Found dependency: " + dependency.modID + ":" + dependency.versionIndex);
                        found = true;
                        break;
                    }
                }
                if (!found)
                {
                    Application.current.window.alert("Mod with ID \"" + mod.meta.modID + "\" depends on mod with ID \"" + dependency.modID + ":" + dependency.versionIndex + "\" which is not loaded.\nUnloading mod...", "Mod Error");
                    loaded.remove(mod);
                }
            }
        }
        #else
        loaded = [];
        #end
    }

    public function initWeeks():Array<Weeks>
    {
        #if !NO_MODDING
        var weeks:Array<Weeks> = [];
        for (mod in loaded)
        {
            var rawJson = File.getContent(mod.path + "/weeks.json");
            trace("Parsing weeks.json for mod: " + mod.name);
            var week:Weeks = Json.parse(rawJson);
            week.mod = mod.name;
            weeks.push(week);
        }
        return weeks;
        #else
        return [];
        #end
    }

    public function image(key:String, modID:String):BitmapData
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return BitmapData.fromFile(mod.path + "/images/" + key + ".png");
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function inst(key:String, modID:String):Sound
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return Sound.fromFile(mod.path + "/songs/" + key + "/Inst.ogg");
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function voices(key:String, modID:String):Sound
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return Sound.fromFile(mod.path + "/songs/" + key + "/Voices.ogg");
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function json(key:String, modID:String):String
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                trace(mod.path + "/" + key + ".json");
                return File.getContent(mod.path + "/" + key + ".json");
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function txt(key:String, modID:String):String
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return File.getContent(mod.path + "/" + key + ".txt");
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function noExtTxt(key:String, modID:String):String
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return File.getContent(mod.path + "/" + key);
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function sparrow(key:String, modID:String):FlxAtlasFrames
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                trace("DINGUS " + key + ", " + modID);
                return FlxAtlasFrames.fromSparrow(image(key, modID), noExtTxt("images/" + key + ".xml", modID));
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function packer(key:String, modID:String):FlxAtlasFrames
    {
        #if !NO_MODDING
        for (mod in loaded)
        {
            if (mod.meta.modID == modID)
            {
                return FlxAtlasFrames.fromSpriteSheetPacker(image(key, modID), noExtTxt("images/" + key + ".xml", modID));
            }
        }
        return null;
        #else
        return null;
        #end
    }

    public function getCharShit(charName:String):CusChar
    {
        #if !NO_MODDING
        var char:CusChar = null;
        for (mod in loaded)
        {
            var rawJson = File.getContent(mod.path + "chars.json");
            trace("Parsing chars.json for mod: " + mod.meta.modID);
            var thing:CharJSON = Json.parse(rawJson);
            for (charT in thing.chars)
            {
                if (charT.name == charName)
                {
                    char = charT;
                    break;
                }
            }
            if (char != null)
                break;
        }
        return char;
        #else
        return null;
        #end
    }
}

typedef Mod = 
{
    name:String,
    meta:ModMeta,
    path:String,
}

typedef ModMeta = {
    modID:String,
    displayName:String,
    author:String,
    credits:Array<String>,
    versionIndex:Int,
    dependencies:Array<ModDependency>
}

typedef ModDependency = {
    modID:String,
    versionIndex:Int,
}

typedef Weeks =
{
    mod:String,
    weeks:Array<Week>,
}

typedef Week =
{
    name:String,
    graphic:String,
    libInclude:Array<String>,
    songs:Array<String>
}

typedef CharJSON = {
	var chars:Array<CusChar>;
}

typedef CusChar = {
	var name:String;
	var graphic:String;
    var color:String;
    var flipX:Bool;
	var animations:Array<CharAnim>;
}

typedef CharAnim = {
	var name:String;
	var anim:String;
	var offsetX:Int;
	var offsetY:Int;
}