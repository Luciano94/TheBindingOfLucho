package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.system.System;

/**
 * ...
 * @author Amaka
 */
class MenuState extends FlxState 
{
	private var playButton:FlxButton;
	private var exitButton:FlxButton;
	private var levelCleared:FlxText;

	override public function create():Void 
	{
		super.create();
		levelCleared = new FlxText(0, 0, 0, "THE BINDING OF LUCHO", 24, true);
		levelCleared.color = FlxColor.WHITE;
		levelCleared.screenCenter();
		levelCleared.y -= (FlxG.height/2) -levelCleared.height;
		add(levelCleared);
		
		playButton = new FlxButton(0,0,"play", clickPlay);
		playButton.screenCenter();
		add(playButton);
		
		exitButton = new FlxButton("Exit", salir);
		exitButton.screenCenter();
		exitButton.y += playButton.height + 20;
		add(exitButton);
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function salir():Void
	{
		System.exit(0);
	}
}