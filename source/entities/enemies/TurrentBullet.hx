package entities.enemies;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import entities.enemies.Turrent;

/**
 * ...
 * @author Amaka
 */
class TurrentBullet extends FlxSprite 
{

	private var speed:Int;
	private var bulletTime:Int;
	private var turrent: Turrent;
	
	public function new(?X:Float=0, ?Y:Float=0, _turrent:Turrent) 
	{
		super(X, Y);
		makeGraphic(4, 4, FlxColor.CYAN);
		speed = Reg.bulletSpeed;
		bulletTime = Reg.bulletTime;
		turrent = _turrent;
		setupDirection();
		Reg.bulletReference = this;
		FlxG.state.add(this);
	}
	
	private function setupDirection():Void
	{
		if (Reg.playerReference.x > x)
			velocity.x = speed;
		else if (Reg.playerReference.x < x)
			velocity.x = -speed;
		if (Reg.playerReference.y > y)
			velocity.y = speed;
		else if (Reg.playerReference.y < y)
			velocity.y = -speed;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (bulletTime > 0)
			bulletTime --;
		else
		{
			bulletTime = Reg.bulletTime;
			turrent.bulletAlive = false;
			destroy();
		}
	}
}