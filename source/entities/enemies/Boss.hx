package entities.enemies;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import states.WinState;
/**
 * ...
 * @author holis
 */
class Boss extends FlxSprite 
{

	public var life:Int; 
	private var speed:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Boss__png, false, 63, 63);
		life = Reg.bossLife;
		speed = Reg.bossSpeed;
		velocity.set(speed, speed);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{
			Reg.bossFight = true;
			super.update(elapsed);
			if (life < 15)
				speed = Reg.bossSpeedBoost;
			behavior();
		}
	}
	
	private function behavior():Void
	{
		if (x > FlxG.camera.scroll.x + FlxG.width - width)
			velocity.x = -speed;
		if (x < FlxG.camera.scroll.x)
			velocity.x = speed;
		if (y > FlxG.camera.scroll.y + FlxG.height - height)
			velocity.y = -speed;
		if (y < FlxG.camera.scroll.y)
			velocity.y = speed;
	}
	
	public function getDamage():Void
	{
		life--;
		if (life <= 0)
		{
			FlxG.state.openSubState(new WinState());
			destroy();
		}
	}
}