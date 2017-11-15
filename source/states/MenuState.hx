package states;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

/**
 * ...
 * @author Amaka
 */
class MenuState extends FlxState 
{
	private var playButton:FlxButton;

	override public function create():Void 
	{
		super.create();
		
		playButton = new FlxButton(0,0,"play", clickPlay);
		playButton.screenCenter();
		add(playButton);
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}