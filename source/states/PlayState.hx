package states;

import entities.Player;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var player:Player;
	
	override public function create():Void
	{
		super.create();
		player = new Player(0, 0);
		player.screenCenter();
		
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}