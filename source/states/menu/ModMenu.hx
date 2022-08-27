package states.menu;
import engine.io.Modding;
import states.menu.OptionsMenu;
import engine.base.ModAPI.ModMeta;
import engine.functions.Option;
import openfl.utils.Dictionary;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import engine.base.Controls.Control;
import engine.util.PlayerSettings;
import engine.util.CoolUtil;
import engine.io.Paths;
import engine.assets.Alphabet;
import engine.base.MusicBeatState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;
class ModMenu extends MusicBeatState
{
	// options are at the top of create() now	
	var optionGroups:Array<ModMeta> = [];

	var curSelectedGroup:Int;

	var categoryBG:FlxSprite;

	var selectorSprite:FlxSprite;

	var focusSprite1:FlxSprite;
	var focusSprite2:FlxSprite;

	var sideText:FlxText;

	override function create()
	{
		if (engine.functions.Option.recieveValue("GRAPHICS_globalAA") == 0)
			{
				FlxG.camera.antialiasing = true;
			}
			else
			{
				FlxG.camera.antialiasing = false;
			}

		for (mod in Modding.api.loaded)
		{
			optionGroups.push(mod.meta);
		}

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var stateBG = new FlxSprite();
		if (Option.recieveValue("VISUALS_darkMode") == 1)
			stateBG.loadGraphic(Paths.image('menuDesat'));
		else
			stateBG.loadGraphic(Paths.image('menuDesatDARK'));
		stateBG.color = 0xFFea71fd;
		stateBG.setGraphicSize(Std.int(stateBG.width * 1.1));
		stateBG.updateHitbox();
		stateBG.screenCenter();
		stateBG.antialiasing = false;
		add(stateBG);

		var menuBG:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.9), Std.int(FlxG.height * 0.9), 0xAA000000);
		menuBG.screenCenter();
		add(menuBG);

		categoryBG = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.9), 0xAA555555);
		categoryBG.setPosition(menuBG.x, menuBG.y);
		add(categoryBG);

		var descriptionBG:FlxSprite = new FlxSprite().makeGraphic(Std.int(menuBG.width - categoryBG.width), Std.int(FlxG.height * 0.05), 0xAA555555);
		descriptionBG.setPosition(categoryBG.x + categoryBG.width, menuBG.y + menuBG.height - descriptionBG.height);
		// add(descriptionBG);

		sideText = new FlxText(menuBG.x + categoryBG.width, menuBG.y + 5, descriptionBG.width, "TEST").setFormat(Paths.font("PhantomMuff.ttf"), 32, 0xFFFFFFFF, LEFT);
		add(sideText);

		
		for (i in 0...optionGroups.length)
		{
			var btnBg:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.05), 0xCC111111);
			btnBg.x = menuBG.x;
			btnBg.y = menuBG.y + (i * Std.int(FlxG.height * 0.05)) + i * 2;
			add(btnBg);
			
			var btnTxt:FlxText = new FlxText(0, 0, btnBg.width, optionGroups[i].displayName);
			btnTxt.setFormat(Paths.font('PhantomMuff.ttf'), 12, 0xFFFFFFFF, CENTER);
			btnTxt.x = btnBg.x;
			btnTxt.y = btnBg.y + btnBg.height / 2 - btnTxt.height / 2;
			add(btnTxt);
		}

		updateMenu();

		selectorSprite = new FlxSprite(0, 0);
		selectorSprite.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.05), 0x55FFFFFF);
		selectorSprite.setPosition(menuBG.x, menuBG.y);
		add(selectorSprite);

		super.create();
		
	}

	override function update(elapsed:Float)
	{
		
		if (FlxG.save.data.UP == null)
			FlxG.save.data.UP = "W";
		if (FlxG.save.data.DOWN == null)
			FlxG.save.data.DOWN = "S";
		if (FlxG.save.data.LEFT == null)
			FlxG.save.data.LEFT = "A";
		if (FlxG.save.data.RIGHT == null)
			FlxG.save.data.RIGHT = "D";

		selectorSprite.y = categoryBG.y + (curSelectedGroup * Std.int(FlxG.height * 0.05)) + curSelectedGroup * 2;

		if (controls.BACK)
		{
			FlxG.switchState(new OptionsMenu());
		}
		if (controls.UP_P)
		{
			if (curSelectedGroup > 0)
			{
				curSelectedGroup--;
				updateMenu();
			}
			else
			{
				curSelectedGroup = optionGroups.length - 1;
				updateMenu();
			}
		}

		if (controls.DOWN_P)
		{
			if (curSelectedGroup < optionGroups.length - 1)
			{
				curSelectedGroup++;
				updateMenu();
			}
			else
			{
				curSelectedGroup = 0;
				updateMenu();
			}
		}

		super.update(elapsed);
		
	}

	function updateMenu()
	{
		// not copied from sublim engine, at all.	
		// updateFPS();

		sideText.text = 'Mod ID: ${optionGroups[curSelectedGroup].modID}'
		+ '\nDisplay Name: ${optionGroups[curSelectedGroup].displayName}'
		+ '\nAuthor: ${optionGroups[curSelectedGroup].author}'
		+ '\nVersion Index: ${optionGroups[curSelectedGroup].versionIndex}'
		+ '\n\nCredits: ';

		for (credit in optionGroups[curSelectedGroup].credits)
		{
			sideText.text += '\n    ${credit}';
		}

		sideText.text += '\n\nDependencies: ';

		for (dependency in optionGroups[curSelectedGroup].dependencies)
		{
			sideText.text += '\n    ${dependency.modID}:${dependency.versionIndex}';
		}

		// idk how shit this math is, copilot made it. but it works :)
		if (selectorSprite != null)
			selectorSprite.y = categoryBG.y + (curSelectedGroup * Std.int(FlxG.height * 0.05)) + curSelectedGroup * 2;
		
	}
}
