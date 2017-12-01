package states;

import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.system.System;

/**
 * ...
 * @author ...
 */
class WinState extends FlxSubState 
{
	private var levelCleared:FlxText;
	private var exitButton: FlxButton;

	public function new(BGColor:FlxColor=FlxColor.BLACK) 
	{
		super(BGColor);
		FlxG.mouse.visible = true;
		levelLostSetUp();
	}
	
	private function levelLostSetUp():Void 
	{
		levelCleared = new FlxText(0, 0, 0, "YOU WIN!!!", 24, true);
		levelCleared.color = FlxColor.WHITE;
		levelCleared.screenCenter();
		add(levelCleared);
		
		exitButton = new FlxButton("Exit", salir);
		exitButton.screenCenter();
		exitButton.y += levelCleared.height + 20;
		add(exitButton);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		levelCleared.setPosition((FlxG.camera.scroll.x + (FlxG.width / 2) - (levelCleared.width / 2)), 
								(FlxG.camera.scroll.y + (FlxG.height / 2) - levelCleared.height));
	}
	
	private function salir():Void
	{
		System.exit(0);
	}
}