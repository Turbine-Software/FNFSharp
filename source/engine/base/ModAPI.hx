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
                if (FileSystem.exists(modFolderPath + file + "/VERSION"))
                {
                    if (Std.parseInt(File.getContent(modFolderPath + file + "/VERSION")) != modVerIndex)
                    {
                        Application.current.window.alert("Mod " + file + " has version index " + File.getContent(modFolderPath + file + "/VERSION") + " but this version of FNF# uses version index " + modVerIndex + ".\n\nThe mod will still run, but some features may not work as expected, or even crash the game. Run at your own risk.", "DEPRECATED MOD");
                    }
                }
                else
                {
                    Application.current.window.alert("FNF# is unable to find the version index of " + file + " and therefore can't determine if the mod is compatable with the current version.\n\nThe mod will still run, but some features may not work as expected, or even crash the game. Run at your own risk.", "FNF# CANNOT DETERMINE MOD VERSION");
                }
                loaded.push({
                    name: file.split("SM.")[1],
                    path: modFolderPath + file
                });
            }
        }
        trace("Found " + loaded.length + " mod(s).");
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

    /**
     * Gets a text file from a mod.
     * @param path the path to the file
     * @param mod the mod to get it from. if `null`, it will loop over all mods and get the first occurance of the file.
     * @return String
     */
    public function getTextShit(path:String, ?mod:Mod):String
    {
        #if !NO_MODDING
        trace("looking for text file: " + path);
        var shit = "";
        if (mod != null)
        {
            trace("getting the path: " + mod.path + path);
            shit = File.getContent(mod.path + path);
        }
        else 
        {
            for (mod in loaded)
            {
                trace("scanning mod: " + mod.name);
                if (FileSystem.exists(mod.path + path))
                {
                    trace("getting the path: " + mod.path + path);
                    shit = File.getContent(mod.path + path);
                    break;
                }
            }
        }
        return shit;
        #else
        return "";
        #end
    }

    public function getSoundShit(path:String, ?mod:Mod):Sound
    {
        #if !NO_MODDING
        trace("looking for sound file: " + path);
        var shit:Sound = null;
        if (mod != null)
        {
            trace("getting the path: " + mod.path + path);
            shit = Sound.fromFile(mod.path + path);
        }
        else 
        {
            for (mod in loaded)
            {
                trace("scanning mod: " + mod.name);
                if (FileSystem.exists(mod.path + path))
                {
                    trace("getting the path: " + mod.path + path);
                    shit = Sound.fromFile(mod.path + path);
                    break;
                }
            }
        }
        return shit;
        #else
        return null;
        #end
    }

    public function getImageShit(path:String, ?mod:Mod):BitmapData
    {
        #if !NO_MODDING
        trace("looking for image file: " + path);
        var shit:BitmapData = null;
        if (mod != null)
        {
            trace("getting the path: " + mod.path + path);
            shit = BitmapData.fromFile(mod.path + path);
        }
        else
        {
            for (mod in loaded)
            {
                trace("scanning mod: " + mod.name);
                if (FileSystem.exists(mod.path + path))
                {
                    trace("getting the path: " + mod.path + path);
                    shit = BitmapData.fromFile(mod.path + path);
                    break;
                }
            }
        }
        return shit;
        #else
        return null;
        #end
    }

    public function getSparrowShit(pathPng:String, pathXml:String, ?mod:Mod):FlxAtlasFrames
    {
        #if !NO_MODDING
        trace("looking for sparrow file: " + pathPng);
        var shit:FlxAtlasFrames = null;
        if (mod != null)
        {
            trace("getting the path: " + pathPng);
            shit = FlxAtlasFrames.fromSparrow(getImageShit(pathPng, mod), getTextShit(pathXml, mod));
        }
        else 
        {
            for (mod in loaded)
            {
                trace("scanning mod: " + mod.name);
                trace("looking for image file: " + mod.path + pathPng);
                if (FileSystem.exists(mod.path + pathPng))
                {
                    trace("getting the path: " +  pathPng);
                    shit = FlxAtlasFrames.fromSparrow(getImageShit(pathPng, mod), getTextShit(pathXml, mod));
                    break;
                }
            }
        }
        return shit;
        #else
        return null;
        #end
    }

    public function getPackerShit(pathPng:String, pathXml:String, ?mod:Mod):FlxAtlasFrames
    {
        #if !NO_MODDING
        trace("looking for sparrow file: " + pathPng);
        var shit:FlxAtlasFrames = null;
        if (mod != null)
        {
            trace("getting the path: " + pathPng);
            shit = FlxAtlasFrames.fromSpriteSheetPacker(getImageShit(pathPng, mod), getTextShit(pathXml, mod));
        }
        else 
        {
            for (mod in loaded)
            {
                trace("scanning mod: " + mod.name);
                if (FileSystem.exists(pathPng))
                {
                    trace("getting the path: " +  pathPng);
                    shit = FlxAtlasFrames.fromSpriteSheetPacker(getImageShit(pathPng, mod), getTextShit(pathXml, mod));
                    break;
                }
            }
        }
        return shit;
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
            var rawJson = File.getContent(mod.path + "/chars.json");
            trace("Parsing chars.json for mod: " + mod.name);
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
    path:String,
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