package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Amaka
 */
class Player extends FlxSprite 
{
	
	private var speed:Int;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		Reg.playerReference = this;
		makeGraphic(64, 64, FlxColor.BLUE);
		
		//init
		speed = Reg.playerSpeed;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(0, 0);
		movement();
		checkBounds();
	}
	
	private function movement():Void
	{
		if (FlxG.keys.pressed.UP)
			velocity.y = -speed;
		if (FlxG.keys.pressed.DOWN)
			velocity.y = speed;
		if (FlxG.keys.pressed.RIGHT)
			velocity.x = speed;
		if (FlxG.keys.pressed.LEFT)
			velocity.x = -speed;
	}
	
	private function checkBounds():Void
	{
		if (x < 0)
			x = 0;
		if (x + width > FlxG.width)
			x = FlxG.width - width;
		
		if (y < 0)
			y = 0;
		if (y + height > FlxG.height)
			y = FlxG.height - height;
	}
	
}