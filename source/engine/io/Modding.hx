package engine.io;

import sys.io.File;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.media.Sound;
import sys.FileSystem;
import engine.base.ModAPI;

using StringTools;

/**
 * Contains helper functions for modding. Also contains a global wrapper of the `ModAPI` class.
 */
class Modding
{
    /**
     * Global wrapper for the `ModAPI` class.
     */
    public static var api:ModAPI;

    /**
     * Weeks of the mods
     */
    public static var weeks:Array<engine.base.ModAPI.Weeks>;

    /**
     * Initializes the modding API.
     */
    public static function init()
    {
        #if !NO_MODDING
        api = new ModAPI();
        api.init("./mods/");
        weeks = api.initWeeks();
        #else
        trace("Modding is disabled.");
        #end
    }

    static function split(key:String):Array<String>
    {
        if (key.indexOf(":") == -1)
        {
            return [];
        }

        return key.split(":");
    }

    public static function image(key:String):BitmapData
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var imageID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared")
        {
            return BitmapData.fromFile("./assets/shared/images/" + imageID + ".png");
        }
        else if (modID == "preload")
        {
            return BitmapData.fromFile("./assets/images/" + imageID + ".png");
        }
        else if (modID.startsWith("LIB_"))
        {
            var lib = modID.split("_")[1];
            return BitmapData.fromFile("./assets/" + lib + "/images/" + imageID + ".png");
        }
        else
        {
            return api.image(imageID, modID);
        }
        #else
        return null;
        #end
    }

    public static function inst(key:String):Sound
    {
        #if !NO_MODDING
        var modID = split(key)[0].trim();
        var instID = split(key)[1] == null ? "" : split(key)[1].trim();

        if (modID == "" || modID == "shared" || modID == "preload" || modID.startsWith("LIB_"))
        {
            trace("./assets/songs/" + instID.toLowerCase() + "/Inst.ogg");
            return Sound.fromFile("./assets/songs/" + instID.toLowerCase() + "/Inst.ogg");
        }
        else
        {
            trace("MOD SONG!!!! " + modID);
            return api.inst(instID, modID);
        }
        #else
        return null;
        #end
    }

    public static function voices(key:String):Sound
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var instID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared" || modID == "preload" || modID.startsWith("LIB_"))
        {
            return Sound.fromFile("./assets/songs/" + instID.toLowerCase() + "/Voices.ogg");
        }
        else
        {
            return api.voices(instID, modID);
        }
        #else
        return null;
        #end
    }

    public static function json(key:String):String
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var jsonID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared")
        {
            return File.getContent("./assets/shared/data/" + jsonID + ".json");
        }
        else if (modID == "preload")
        {
            return File.getContent("./assets/data/" + jsonID + ".json");
        }
        else if (modID.startsWith("LIB_"))
        {
            var lib = modID.split("_")[1];
            return File.getContent("./assets/" + lib + "/data/" + jsonID + ".json");
        }
        else
        {
            return api.json(jsonID, modID);
        }
        #else
        return "";
        #end
    }

    public static function txt(key:String):String
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var txtID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared")
        {
            return File.getContent("./assets/shared/data/" + txtID + ".txt");
        }
        else if (modID == "preload")
        {
            return File.getContent("./assets/data/" + txtID + ".txt");
        }
        else if (modID.startsWith("LIB_"))
        {
            var lib = modID.split("_")[1];
            return File.getContent("./assets/" + lib + "/data/" + txtID + ".txt");
        }
        else
        {
            return api.txt(txtID, modID);
        }
        #else
        return "";
        #end
    }

    public static function sparrow(key:String):FlxAtlasFrames
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var txtID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared")
        {
            return Paths.getSparrowAtlas(txtID, "shared");
        }
        else if (modID == "preload")
        {
            return Paths.getSparrowAtlas(txtID, "preload");
        }
        else if (modID.startsWith("LIB_"))
        {
            var lib = modID.split("_")[1];
            return Paths.getSparrowAtlas(txtID, lib);
        }
        else
        {
            return api.sparrow(txtID, modID);
        }
        #else
        return null;
        #end
    }

    public static function packer(key:String):FlxAtlasFrames
    {
        #if !NO_MODDING
        var modID = split(key)[0];
        var txtID = split(key)[1] == null ? "" : split(key)[1];

        if (modID == "" || modID == "shared")
        {
            return Paths.getPackerAtlas(txtID, "shared");
        }
        else if (modID == "preload")
        {
            return Paths.getPackerAtlas(txtID, "preload");
        }
        else if (modID.startsWith("LIB_"))
        {
            var lib = modID.split("_")[1];
            return Paths.getPackerAtlas(txtID, lib);
        }
        else
        {
            return api.packer(txtID, modID);
        }
        #else
        return null;
        #end
    }
}